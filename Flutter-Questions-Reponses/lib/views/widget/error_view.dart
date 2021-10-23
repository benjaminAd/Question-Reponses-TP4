import 'package:flutter/material.dart';

class ErrorView extends StatelessWidget {
  late String _error;

  ErrorView({Key? key, required String error}) : super(key: key) {
    this._error = error;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.error_outline,
          color: Theme.of(context).colorScheme.onError,
          size: 60,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Text(
            'Error: ${this._error}',
            style: TextStyle(color: Theme.of(context).colorScheme.onError),
          ),
        )
      ],
    );
  }
}
