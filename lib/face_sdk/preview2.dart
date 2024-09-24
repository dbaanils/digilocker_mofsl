import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:ainxt_digilocker_mod/face_sdk/instructions.dart';
import 'package:ainxt_digilocker_mod/face_sdk/themefiles/app_colors.dart';
import 'package:ainxt_digilocker_mod/face_sdk/util/common.dart';
import 'package:ainxt_digilocker_mod/face_sdk/util/statesScreens.dart';
import 'package:camera/camera.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';

class FaceSdkScreen extends StatefulWidget {
  final String keyString;
  final String authToken;
  final String baseUrl;

  const FaceSdkScreen({
    Key? key,
    required this.baseUrl,
    required this.keyString,
    required this.authToken,
  }) : super(key: key);

  @override
  FaceSdkScreenState createState() => FaceSdkScreenState();
}

class FaceSdkScreenState extends State<FaceSdkScreen> {
  List<CameraDescription> _cameras = [];

  double _loadingImageOffsetY = 100; // Initial offset
  final double _loadingImageTargetOffsetY = -20; // Target offset (centered)
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableLandmarks: true,
      performanceMode: FaceDetectorMode.accurate,
      enableClassification: true,
      minFaceSize: .2,
    ),
  );

  bool _hasFace = false,
      _isTooClose = false,
      _showImage2 = false,
      _isTooFar = false,
      _isBusy = false,
      _permissionDenied = false,
      _loaded = false,
      _uploading = false,
      _showFailedImage = false,
      _showInstructions = true,
      _isCameraOn = false;

  CameraController? _controller;
  int _cameraIndex = 0;
  Position? _position;

  late Uint8List _bytesImage2;
  dynamic _uniqueId;
  String _failedMessage = "";

  final _player = AudioPlayer();

  @override
  void initState() {
    _startLive();
    super.initState();
  }

//checking the permissions and starting
  Future _startLive() async {
    late Map<Permission, PermissionStatus> status;
    await Future.delayed(
      const Duration(milliseconds: 500),
      () async {
        status = await [Permission.location, Permission.camera].request();
      },
    ).then(
      (_) async {
        if (status[Permission.camera] == PermissionStatus.granted &&
            status[Permission.location] == PermissionStatus.granted) {

          try {
            _position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high,
            );
            if (_cameras.isEmpty) {
              _cameras = await availableCameras();
            }
            for (var i = 0; i < _cameras.length; i++) {
              if (_cameras[i].lensDirection == CameraLensDirection.front) {
                _cameraIndex = i;
                break;
              }
            }

            if (_cameraIndex != -1) {
              _startLiveFeed();
            }
          } catch (e) {
            setState(() => _permissionDenied = true);
          }
        } else {
          setState(() => _permissionDenied = true);
        }
      },
    );
  }

//starting the camera controller and image stream
  Future _startLiveFeed() async {
    final camera = _cameras[_cameraIndex];
    _controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
    );
    _controller?.initialize().then(
      (_) {
        if (!mounted) {
          return;
        }
        Future.delayed(
          const Duration(seconds: 2),
          () => setState(() => _loaded = true),
        );

        //locking orientation to be portrait
        _controller!.lockCaptureOrientation(DeviceOrientation.portraitUp);
        _controller?.startImageStream(_processCameraImage);
        _isCameraOn = true;
        setState(() {});
      },
    );
  }

  //processing the image streamed by camera controller
  void _processCameraImage(CameraImage image) async {
    final inputImage = _inputImageFromCameraImage(image);
    if (inputImage == null) return;
    await _processImage(inputImage);
  }

  InputImage? _inputImageFromCameraImage(CameraImage image) {
    if (_controller == null) return null;
    final WriteBuffer allBytes = WriteBuffer();
    if (Platform.isAndroid) {
      for (Plane plane in image.planes) {
        allBytes.putUint8List(plane.bytes);
      }
    }
    final orientations = {
      DeviceOrientation.portraitUp: 0,
      DeviceOrientation.landscapeLeft: 90,
      DeviceOrientation.portraitDown: 180,
      DeviceOrientation.landscapeRight: 270,
    };
    final camera = _cameras[_cameraIndex];
    final sensorOrientation = camera.sensorOrientation;
    InputImageRotation? rotation;
    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (Platform.isAndroid) {
      var rotationCompensation =
          orientations[_controller!.value.deviceOrientation];
      if (rotationCompensation == null) return null;
      if (camera.lensDirection == CameraLensDirection.front) {
        rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
      } else {
        rotationCompensation =
            (sensorOrientation - rotationCompensation + 360) % 360;
      }
      rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
    }
    if (rotation == null) return null;

    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    if (format == null ||
        (Platform.isAndroid && format != InputImageFormat.nv21) ||
        (Platform.isIOS && (format != InputImageFormat.bgra8888))) return null;

    if (image.planes.length != 1) return null;
    final plane = image.planes.first;

    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: plane.bytesPerRow,
      ),
    );
  }

  //processing the image and checking for the face
  Future<void> _processImage(InputImage inputImage) async {
    if (_isBusy) return;
    _isBusy = true;

    await Future.delayed(const Duration(milliseconds: 200));
    try {
      final faces = await _faceDetector.processImage(inputImage);
      setState(
        () {
          if (faces.isNotEmpty) {
            try {
              final face = faces.first;

              // Face landmark point names
              const landmarks = {
                'noseBase': FaceLandmarkType.noseBase,
                'leftEye': FaceLandmarkType.leftEye,
                'rightEye': FaceLandmarkType.rightEye,
              };

              // Calibrated pupillary distance
              const double calibratedPupillaryDistance = 5.5;

              // Camera angle to the face
              const double cameraAngle = 22.5;
              // Get facial landmarks
              final landmarksMap = face.landmarks;

              // Calculate pupillary distance based on calibrated landmarks
              final leftEye = landmarksMap[landmarks['leftEye']]!;
              final rightEye = landmarksMap[landmarks['rightEye']]!;
              final pupillaryDistance = sqrt(
                pow(leftEye.position.x - rightEye.position.x, 2) +
                    pow(leftEye.position.y - rightEye.position.y, 2),
              );

              // Adjust pupillary distance based on calibration
              final adjustedPupillaryDistance =
                  pupillaryDistance / calibratedPupillaryDistance;

              // Convert camera angle to radians
              const cameraAngleRadians = cameraAngle * (pi / 180);

              // Calculate distance from face to camera
              final faceDistance =
                  adjustedPupillaryDistance / tan(cameraAngleRadians);

              // if(Platform.isIOS){
              //   _isTooClose = faceDistance > 90;
              //   _isTooFar = faceDistance < 40 && faceDistance > 10;
              // }else{
              //   _isTooClose = faceDistance > 90;
              //   _isTooFar = faceDistance < 40 && faceDistance > 10;
              // }
              _isTooClose = faceDistance > 90;
              _isTooFar = faceDistance < 40 && faceDistance > 10;
              print("FD:$faceDistance");

              //test for too far,too close or out of the frame
              if (!_isTooClose &&
                  !_isTooFar &&
                  _isFaceInCircle(face, inputImage.metadata!.size)) {
                _hasFace = true;
              } else {
                _hasFace = false;
              }
              setState(() {});
              return;
            } catch (e) {
              if (kDebugMode) {
                print("exception during process image: $e");
              }
            }
          }
          _hasFace = false;
          _isTooClose = false;
          _isTooFar = false;
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }

  bool _isFaceInCircle(Face face, Size imageSize) {
    final boundingBox = face.boundingBox;
    final circleOffset = Offset(imageSize.width / 2, imageSize.height / 2);
    // final circleRadius = imageSize.width / 3;
    final faceCenterX = boundingBox.center.dx;
    final faceCenterY = boundingBox.center.dy;
    final xDistance = faceCenterX - circleOffset.dx;
    final yDistance = faceCenterY - circleOffset.dy;
    final sum = (pow(xDistance, 2) + pow(yDistance, 2));
    print(sum);
    if (Platform.isIOS) {
      return sum <= 20000;
    } else {
      return sum <= 200000 && sum > 100000;
    }
  }

  //capturing the image and sending to server for validation
  Future _captureImage() async {
    if (_hasFace && !_isTooClose && !_isTooFar && _isCameraOn) {
      try {
        if (!_controller!.value.isInitialized) return;
        _controller!.stopImageStream();
        setState(() => _isCameraOn = false);
        try {
          _player.setAsset('packages/ainxt_digilocker_mod/faceplugin/assets/camera_click.mp3');
          _player.play();
          var fileImage = await _controller!.takePicture();
          var bytesImage = await fileImage.readAsBytes();
          _loaded = false;
          _uploading = true;
          setState(() {});

          String url =
              "${widget.baseUrl}?LATITUDE=${_position!.latitude}&LONGITUDE=${_position!.longitude}&is_sdk=1";

          String img = base64Encode(bytesImage.toList());
          var request = http.MultipartRequest('POST', Uri.parse(url))
            ..headers.addAll(
              {
                "x-api-key": widget.keyString,
                "authorizationToken": widget.authToken
              },
            )
            ..fields.addAll({'img': "b'$img'"});
          http.Response response =
              await http.Response.fromStream(await request.send());
          _bytesImage2 = bytesImage;
          if (response.statusCode == 200) {
            var body = jsonDecode(response.body) as Map<String, dynamic>;
            if (body['is_valid'] == 1 ||
                body['remark'] == 'Face Analysis Successful') {
              _uniqueId = body['Unique_Id'];
              _showImage2 = true;
              _showFailedImage = false;
              _loaded = true;
              _uploading = false;
              setState(() {});
              try {
                await Future.delayed(const Duration(seconds: 2));
                if (mounted) {
                  Navigator.pop(context, _uniqueId);
                }
              } catch (e) {
                if (kDebugMode) {
                  print("success E: $e");
                }
              }
            } else {
              _showFailedImage = true;
              _failedMessage = body['remark'];
              _loaded = true;
              _uploading = false;
              _hasFace = false;
              setState(() {});
            }
            _player.stop();
          } else {
            if (kDebugMode) {
              print("${response.statusCode}: ${response.body}");
            }
            _restartService(
                "Can't detect face in the picture, please try again");
          }
        } catch (e) {
          if (kDebugMode) {
            print("technical exception: $e");
          }
          _restartService("Some technical error  ");
        }
      } on CameraException catch (e) {
        if (kDebugMode) {
          print("Camera exception error: $e");
        }
        // showErrorSnackBar("Failed to capture your image, please try again");
      }
    } else {}
  }

  void _restartService(message) {
    if (message != "") {
      _showErrorSnackBar(message);
    }
    _uploading = false;
    _showImage2 = false;
    _showFailedImage = false;
    _loaded = true;
    _uniqueId = "";
    setState(() {});
    _controller!.startImageStream(_processCameraImage);
    setState(() => _isCameraOn = true);
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 12.0)),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          margin: const EdgeInsets.only(bottom: 90, right: 20, left: 20),
        ),
      );
  }

  // void _successSnackBar(String message) {
  //   ScaffoldMessenger.of(context)
  //     ..removeCurrentSnackBar()
  //     ..showSnackBar(
  //       SnackBar(
  //         content: Text(message.toString(),
  //             textAlign: TextAlign.center,
  //             style: const TextStyle(color: Colors.white, fontSize: 12.0)),
  //         behavior: SnackBarBehavior.floating,
  //         backgroundColor: Colors.green,
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(24),
  //         ),
  //         margin: const EdgeInsets.only(bottom: 90, right: 20, left: 20),
  //       ),
  //     );
  // }

//stops the image stream
  // Future _stopLiveFeed() async {
  //   await _controller?.stopImageStream();
  //   await _controller?.dispose();
  //   _controller = null;
  // }
  Future _stopLiveFeed() async {
    if(_controller.value.isStreamingImages){
      await _controller?.stopImageStream();
    }
    await _controller?.dispose();
    _controller = null;
  }

  @override
  void dispose() {
    _stopLiveFeed();
    _faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _showInstructions
      ? InstructionsScreen(
          onButtonTap: () {
            setState(() => _showInstructions = false);
            Future.delayed(
                const Duration(seconds: 1),
                () => setState(
                    () => _loadingImageOffsetY = _loadingImageTargetOffsetY));
          },
        )
      : Scaffold(
          backgroundColor:
              AppThemeColors.getColor(AppThemeColorsEnum.background, context),
          appBar: _showFailedImage || _showImage2 || _uploading || !_loaded
              ? null
              : instructionAppBar(context),
          body: SafeArea(
            child: _loaded
                ? Container(
                    color: _showImage2 || _showFailedImage
                        ? AppColors.backgroundDarkVarient2
                        : AppThemeColors.getColor(
                            AppThemeColorsEnum.background, context),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        !_showFailedImage
                            ? Expanded(
                                child: Center(
                                  child: (_showImage2)
                                      ? successMessageScreenTop(context)
                                      : (!_showFailedImage && !_showImage2)
                                          ? Text(
                                              _isTooClose
                                                  ? "Face too close"
                                                  : _isTooFar
                                                      ? "Face too far"
                                                      : _hasFace
                                                          ? "You can capture your selfie now"
                                                          : "Place your face within the circle",
                                              style: TextStyle(
                                                color: _hasFace
                                                    ? Colors.green
                                                    : Colors.red,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 18, //.ssp,
                                              ),
                                            )
                                          : const SizedBox(),
                                ),
                              )
                            : SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.15,
                              ),

                        //Live Camera and Success & Fail Image Preview

                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: _showImage2 ? 50.0 : 24),
                          child: Container(
                            //width: 0.90,//.sw,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: _showImage2 || _showFailedImage
                                    ? 35
                                    : 5, //.sp,
                                color: _showImage2 || _showFailedImage
                                    ? AppColors.backgroundDarkVarient
                                    : _hasFace && !_isTooClose && !_isTooFar
                                        ? AppColors.success
                                        : AppColors.fail,
                              ),
                            ),
                            child: _controller?.value.isInitialized != false
                                ? AspectRatio(
                                    aspectRatio: 1 / 1,
                                    child: ClipOval(
                                      child: Transform.scale(
                                        scale: 2,
                                        child: Center(
                                          child: _showImage2 || _showFailedImage
                                              ? Image.memory(_bytesImage2)
                                              : CameraPreview(_controller!),
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                          ),
                        ),
                        //Footer Section
                        Expanded(
                          child: _showImage2
                              ? successMessageScreen(context)
                              : _showFailedImage
                                  ? failedMessageScreen(context,
                                      failedMessage: _failedMessage,
                                      onPressed: () => _restartService(""))
                                  : cameraScreenFooter(
                                      context,
                                      onTap: () => _captureImage(),
                                      hasFace: _hasFace,
                                      isTooClose: _isTooClose,
                                      isTooFar: _isTooFar,
                                    ),
                        ),
                        const SizedBox(height: 20),
                        footer(context),
                        const SizedBox(height: 40),
                      ],
                    ),
                  )
                : Center(
                    child: _permissionDenied
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                  "Camera and Location permissions are required to proceed"),
                              ElevatedButton(
                                  onPressed: () {
                                    _permissionDenied = false;
                                    setState(() {});
                                    _startLive();
                                  },
                                  child: const Text("Request Again"))
                            ],
                          )
                        : (_uploading)
                            ? commonLoading()
                            : instructionLoading(context, _loadingImageOffsetY),
                  ),
          ),
        );
}
