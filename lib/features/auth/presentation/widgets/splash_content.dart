import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../../app/app_config.dart';
// import '../../../../core/widgets/globe_background.dart';

class SplashContent extends StatelessWidget {
  final AnimationController? animController;
  final void Function(LottieComposition)? onLoaded;

  const SplashContent({super.key, this.animController, this.onLoaded});

  @override
  Widget build(BuildContext context) {
    final logoPath = AppConfig.isInitialized
        ? AppConfig.current.logoPath
        : 'assets/logo/peers_global_logo.png';

    return Stack(
      children: [
        // Earth background commented out to focus solely on the centered logo animation:
        // const Positioned.fill(child: GlobeBackground(bottomOffset: 65)),
        Center(
          child: SizedBox(
            width: 360,
            height: 360,
            child: Lottie.asset(
              'assets/animationes/splash.json',
              controller: animController,
              repeat: false,
              onLoaded: onLoaded,
              fit: BoxFit.contain,
              frameBuilder: (context, child, composition) {
                if (composition == null) {
                  return Center(
                    child: Image.asset(
                      logoPath,
                      width: 160,
                      height: 160,
                      fit: BoxFit.contain,
                    ),
                  );
                }
                return child;
              },
            ),
          ),
        ),
      ],
    );
  }
}
