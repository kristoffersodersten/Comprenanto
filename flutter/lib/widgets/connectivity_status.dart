import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:provider/provider.dart';

class ConnectivityStatus extends StatelessWidget {
  const ConnectivityStatus({super.key});

  @override
  Widget build(BuildContext context) {
    final connectivityResult = context.watch<ConnectivityResult?>();

    return Container(
      color: connectivityResult == ConnectivityResult.none
          ? Colors.red
          : Colors.green,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          connectivityResult == ConnectivityResult.none
              ? 'Offline'
              : 'Online',
          style: const TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
