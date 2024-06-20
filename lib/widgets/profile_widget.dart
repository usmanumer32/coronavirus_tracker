import 'package:flutter/material.dart';

class UserData extends StatelessWidget {
  const UserData({
    Key key,
    @required this.icon,
    @required this.text,
  }) : super(key: key);

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              width: 100,
              child: Icon(
                icon,
                color: Colors.black54,
                size: 30.0,
              ),
            ),
            Container(
              width: 200,
              child: text.length > 18
                  ? Text(text.substring(0, 18) + '...',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black54,
                      ))
                  : Text(
                      text,
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black54,
                      ),
                    ),
            ),
          ],
        ),
        SizedBox(
          height: 8.0,
        ),
        Divider(
          height: 5.0,
          color: Colors.black26,
        ),
        SizedBox(
          height: 8.0,
        ),
      ],
    );
  }
}
