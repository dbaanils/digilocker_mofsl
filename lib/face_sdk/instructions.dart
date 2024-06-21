import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InstructionsScreen extends StatelessWidget {
  final VoidCallback onButtonTap;

  const InstructionsScreen({super.key, required this.onButtonTap});

  static const _titles = [
    "Ensure that your face is visible clearly",
    "Please look directly into the camera",
    "Please remove spectacles, masks, hats",
  ];
  static const _icons = [
    "packages/ainxt_digilocker_mod/faceplugin/assets/happiness.svg",
    "packages/ainxt_digilocker_mod/faceplugin/assets/camera.svg",
    "packages/ainxt_digilocker_mod/faceplugin/assets/eye-glasses.svg",
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: ShapeDecoration(
                      color: const Color(0xFFFCAF17),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                    ),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        'Selfie Tips',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF333333),
                          fontSize: 33.25,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w700,
                          height: 0,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                            MediaQuery.of(context).size.height * .04),
                        child: ListView.separated(
                          itemBuilder: (context, index) => Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(_icons[index]),
                              const SizedBox(width: 10),
                              Text(
                                _titles[index],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Color(0xFF333333),
                                  fontSize: 14,
                                  fontFamily: 'Lato',
                                  fontWeight: FontWeight.w500,
                                  height: 0,
                                ),
                              ),
                            ],
                          ),
                          itemCount: 3,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 20),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                        ),
                      ),
                      const SizedBox(height: 40),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 5,
                          fixedSize: const Size(150, 46),
                          backgroundColor: const Color(0xFFFCAF17),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6)),
                        ),
                        onPressed: onButtonTap,
                        child: const Text(
                          'Click Photo',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF333333),
                            fontSize: 18,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.w500,
                            height: 0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text.rich(
                        textAlign: TextAlign.center,
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "Powered by ",
                              style: TextStyle(
                                color: Color(0xFF9DA3AE),
                                fontSize: 16.62,
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                            TextSpan(
                              text: "AiNxt",
                              style: TextStyle(
                                color: Color(0xFF9DA3AE),
                                fontSize: 16.62,
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w700,
                                height: 0,
                              ),
                            )
                          ],
                        ),
                      ),
                      MediaQuery.of(context).size.height < 600
                          ? const SizedBox()
                          :  SizedBox(height: MediaQuery.of(context).size.height *.1),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * .17,
              left: MediaQuery.of(context).size.width * .22,
              child: Container(
                width: 204.11,
                height: 204.11,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: AssetImage(
                            "packages/ainxt_digilocker_mod/faceplugin/assets/selfie.png"))),
              ),
            ),
          ],
        ),
      );
}
