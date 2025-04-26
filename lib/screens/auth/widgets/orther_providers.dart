import 'package:flutter/material.dart';
import 'package:flutter_firebase/colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OrtherProviders extends StatelessWidget {
  final void Function() handleGoogleLogin;
  const OrtherProviders({
    super.key,
    required this.handleGoogleLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 16,
      children: [
        Row(
          children: [
            Expanded(
              child: Divider(
                thickness: 1,
                color: Colors.grey[300],
              ),
            ),
            const Text(
              'Ou entre com',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            Expanded(
              child: Divider(
                thickness: 1,
                color: Colors.grey[300],
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.center,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: CapybaColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: CapybaColors.gray2,
                  width: 0.5,
                ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              elevation: 0,
            ),
            onPressed: handleGoogleLogin,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return CapybaColors.greenGradient.createShader(bounds);
                  },
                  child: const FaIcon(
                    FontAwesomeIcons.google,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  "Google",
                  style: TextStyle(
                    color: CapybaColors.gray1,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
