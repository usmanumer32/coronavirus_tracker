import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CountryData extends StatelessWidget {
  final String countryName;
  final int amount;

  CountryData(
    this.countryName,
    this.amount,
  );

  @override
  Widget build(BuildContext context) {
    final formatter = new NumberFormat("#,###");
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: (MediaQuery.of(context).size.width / 2) - 20,
              child: Center(
                child: Text(
                  countryName,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black54,
                  ),
                ),
              ),
            ),
            Container(
              width: (MediaQuery.of(context).size.width / 2) - 20,
              child: Center(
                child: Text(
                  formatter.format(amount),
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
