import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget(
      {super.key, required this.child, required this.isLoading});
  final Widget child;
  final bool isLoading;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading) ...[
         
          const Center(
            child: CircularProgressIndicator(color: Colors.red,),
          ),
           Container(
            color: Colors.black.withOpacity(0.7),
          ),
        ]
      ],
    );
  }
}
