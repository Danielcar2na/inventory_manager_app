import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobileBody;
  final Widget webBody;

  const ResponsiveLayout({
    required this.mobileBody,
    required this.webBody,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return webBody; // Pantallas grandes (tablets y web)
        } else {
          return mobileBody; // Móviles
        }
      },
    );
  }
}
