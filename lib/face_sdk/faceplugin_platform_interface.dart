import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'faceplugin_method_channel.dart';

abstract class FacepluginPlatform extends PlatformInterface {
  /// Constructs a FacepluginPlatform.
  FacepluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static FacepluginPlatform _instance = MethodChannelFaceplugin();

  /// The default instance of [FacepluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelFaceplugin].
  static FacepluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FacepluginPlatform] when
  /// they register themselves.
  static set instance(FacepluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
