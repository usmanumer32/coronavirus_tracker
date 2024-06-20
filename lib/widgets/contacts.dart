import 'package:flutter/material.dart';

class StateContact extends StatelessWidget {
  final String stateName;
  final String phone;
  final String imgUrl;

  StateContact(
    this.stateName,
    this.phone,
    this.imgUrl
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.asset(
                imgUrl,
                width: 35.0,
              ),
            ),
            Container(
              width: (MediaQuery.of(context).size.width / 2) - 50,
              child: Center(
                child: Text(
                  stateName,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black54,
                  ),
                ),
              ),
            ),
            Container(
              width: (MediaQuery.of(context).size.width / 2) - 50,
              child: Center(
                child: Text(
                  phone,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black54,
                  ),
                ),
              ),
            ),
          ],
        ),
        Divider(height: 30.0, color: Colors.grey)
      ],
    );
  }
}
