import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:questions_reponses/views/widget/switch_theme.dart';

class FloatingActionCustom extends StatelessWidget {
  const FloatingActionCustom({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
          onPressed: () {
            _showPicker(context);
          },
          child: Icon(FontAwesomeIcons.cog),);
  }

   void _showPicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height*0.1,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Thème",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.05),
                    ),
                    ChangeThemeButtonWidget(),
                  ],
                )
              ],
            ),
          );
        });
  }
}