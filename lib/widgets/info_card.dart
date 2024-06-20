import 'package:intl/intl.dart';

import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({
    Key key,
    @required this.color,
    @required this.imgUrl,
    @required this.amount,
    @required this.text,
    @required this.textColor,
  }) : super(key: key);

  final Color color;
  final String imgUrl;
  final int amount;
  final String text;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final formatter = new NumberFormat("#,###");
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        height: 125,
        child: Material(
          color: color,
          elevation: 14.0,
          borderRadius: BorderRadius.circular(24.0),
          shadowColor: Color(0x802196F3),
          child: Row(
            children: <Widget>[
              Container(
                width: 115,
                margin: EdgeInsets.only(left: 1),
                child: Container(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Image.asset(imgUrl),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 65, top: 40),
                child: Column(
                  children: <Widget>[
                    Text(
                      formatter.format(amount),
                      style: TextStyle(color: textColor, fontSize: 28),
                    ),
                    Text(text,
                        style: TextStyle(color: textColor, fontSize: 20)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
