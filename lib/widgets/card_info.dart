import 'package:flutter/material.dart';

class CardInformation extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;

  const CardInformation({
    Key key,
    this.imageUrl,
    this.title,
    this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        height: 185,
        child: Material(
          // color: color,
          elevation: 14.0,
          borderRadius: BorderRadius.circular(24.0),
          shadowColor: Color(0x802196F3),
          child: Row(
            children: <Widget>[
              Container(
                width: 80,
                margin: EdgeInsets.only(left: 1),
                child: Container(
                  child: Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Image.asset(imageUrl),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: (MediaQuery.of(context).size.width) - 130,
                      //child: Center(
                      child: Text(
                        title,
                        style: TextStyle(fontSize: 18.0),
                      ),
                      //),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Container(
                      width: (MediaQuery.of(context).size.width) - 130,
                      child: Center(
                        child: Text(
                          description,
                          style:
                              TextStyle(fontSize: 16.0, color: Colors.black54),
                        ),
                      ),
                    ),
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
