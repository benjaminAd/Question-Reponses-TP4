import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.onBackground),
          width: 60,
          height: 60,
        ),
        Padding(
          padding: EdgeInsets.only(top: 16),
          child: Text(
            "Récupération des données...",
            style: TextStyle(
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
        )
      ],
    );
  }
}
