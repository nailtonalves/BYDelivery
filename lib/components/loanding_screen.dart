import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.50),
      child: const Center(
        child:
            CircularProgressIndicator(), // Um indicador de progresso (pode ser personalizado)
      ),
    );
  }
}
