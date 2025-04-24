import 'package:flutter/material.dart';
import 'package:flutter_firebase/colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ImageInput extends StatefulWidget {
  final String labelText;
  final Function() handleOnTap;

  const ImageInput({
    super.key,
    required this.labelText,
    required this.handleOnTap,
  });

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Imagens",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        ElevatedButton(
          onPressed: widget.handleOnTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: CapybaColors.white,
            padding: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13),
              side: BorderSide(
                color: CapybaColors.capybaGreen,
                width: 2.0,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(
                FontAwesomeIcons.fileImage,
                color: CapybaColors.black,
              ),
              const SizedBox(width: 8),
              Text(
                "Escolha uma imagem para anexar",
                style: TextStyle(
                  color: CapybaColors.black,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
