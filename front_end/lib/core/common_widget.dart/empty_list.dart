import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ImageDescriptionTemplate extends StatelessWidget {
  final String imageUrl;
  final Widget title;
  final String description;
  final bool haveButton;
  final String buttonText;
  final VoidCallback? onPressed;
  const ImageDescriptionTemplate({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.haveButton,
    this.buttonText = 'Start Chat',
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isSvg = imageUrl.endsWith('.svg');
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.,
        children: [
          const SizedBox(height: 20),
          Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: MediaQuery.of(context).size.width * 0.7,
              decoration: BoxDecoration(
                  border:
                      isSvg ? null : Border.all(color: Colors.grey, width: 2),
                  borderRadius: isSvg
                      ? null
                      : BorderRadius.circular(
                          MediaQuery.of(context).size.width * 0.5)),
              child: isSvg
                  ? SvgPicture.asset(
                      imageUrl,
                      width: MediaQuery.of(context).size.width * 0.7,
                      height: MediaQuery.of(context).size.width * 0.7,
                    )
                  : ClipOval(
                      child: Image.asset(
                        imageUrl,
                        fit: BoxFit
                            .cover, // Ensures the image covers the container
                        width: MediaQuery.of(context).size.width * 0.7,
                        height: MediaQuery.of(context).size.width * 0.7,
                      ),
                    )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: title,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Center(
                child: Text(
              description,
              style: const TextStyle(
                  fontSize: 16, color: Color(0xff718096)),
              textAlign: TextAlign.center,
            )),
          ),
          const SizedBox(
            height: 10,
          ),
          haveButton
              ? TextButton(
                  onPressed: onPressed,
                  style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                          Theme.of(context).colorScheme.surface),
                      padding: WidgetStateProperty.all(
                          const EdgeInsets.only(left: 40, right: 40, top: 0)),
                      textStyle: WidgetStateProperty.all(TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.onSurface))),
                  child: Text(
                    buttonText,
                    style: const TextStyle(color: Colors.purpleAccent),
                  ))
              : Container()
        ],
      ),
    );
  }
}
