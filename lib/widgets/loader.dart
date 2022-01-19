import 'package:flutter/material.dart';
import 'package:my_contacts_app/resources/strings.dart';

class Loader extends StatelessWidget {
  final bool isLoading;
  final String? loadingMessage;
  final Widget child;

  const Loader({
    required this.isLoading,
    required this.child,
    this.loadingMessage,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 12),
                Text(
                  loadingMessage ?? Strings.loading,
                  textScaleFactor: 1.4,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
