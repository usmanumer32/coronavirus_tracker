import 'package:coronavirus_tracker/models/country.dart';
import 'package:coronavirus_tracker/models/piechart_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/svg.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:intl/intl.dart';

import '../widgets/profile_widget.dart';
import '../providers/covid_provider.dart';

class Profile extends StatefulWidget {
  static const routeName = '/info-by-country';

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  List<DropdownMenuItem<String>> _dropdownMenuItems = [];
  String _selectedCountry;
  List<Country> _countries = [];
  List<String> _countryNames;
  String _flagUrl;
  int _cases;
  int _deaths;
  int _recovered;
  int _index;
  var _isLoading = false;
  String _selectedLanguage;

  @override
  void initState() {
    _isLoading = true;
    _countryNames =
        Provider.of<CovidProvider>(context, listen: false).countryNames;
    _countries = Provider.of<CovidProvider>(context, listen: false).countries;
    _countryNames.forEach(
      (countryName) => _dropdownMenuItems.add(
        DropdownMenuItem<String>(
          child: Text(countryName, overflow: TextOverflow.ellipsis),
          value: countryName,
        ),
      ),
    );
    for (int i = 0; i < _dropdownMenuItems.length; i++) {
      if (_dropdownMenuItems[i].value == 'Ethiopia') {
        _selectedCountry = _dropdownMenuItems[i].value;
        _index = i;
      }
    }

    _flagUrl = _countries[_index].flag;
    _isLoading = false;

    _seriesPieData = List<charts.Series<PieChartData, String>>();
    super.initState();
  }

  didChangeDependencies() async {
    _isLoading = true;
    await Provider.of<CovidProvider>(context, listen: false).getLanguage();
    setState(() {
      _selectedLanguage =
          Provider.of<CovidProvider>(context, listen: false).language;
    });
    await Provider.of<CovidProvider>(context, listen: false)
        .getReportByCountry('ET');
    setState(() {
      _cases =
          Provider.of<CovidProvider>(context, listen: false).casesByCountry;
      _deaths =
          Provider.of<CovidProvider>(context, listen: false).deathsByCountry;
      _recovered =
          Provider.of<CovidProvider>(context, listen: false).recoveredByCountry;
    });
    _generateData();
    _isLoading = false;
    super.didChangeDependencies();
  }

  List<charts.Series<PieChartData, String>> _seriesPieData;
  _generateData() {
    _seriesPieData = [];
    var pieData = Provider.of<CovidProvider>(context, listen: false).pieData;
    _seriesPieData.add(
      charts.Series(
        //data
        data: pieData,
        domainFn: (PieChartData data, _) => data.title,
        measureFn: (PieChartData data, _) => data.percentageValue,
        colorFn: (PieChartData data, _) =>
            charts.ColorUtil.fromDartColor(data.colorValue),
        id: 'Covid-19 Report',
        labelAccessorFn: (PieChartData row, _) => '${row.percentageValue}',
      ),
    );
  }

  changeDropdownItem(String selectedCountry) async {
    _isLoading = true;
    setState(() {
      _selectedCountry = selectedCountry;
    });
    for (int i = 0; i < _countries.length; i++) {
      if (_countries[i].name == _selectedCountry) {
        setState(() {
          _flagUrl = _countries[i].flag;
          _index = i;
        });
        break;
      }
    }

    List<String> coutryCodes =
        Provider.of<CovidProvider>(context, listen: false).countryCodes;
    await Provider.of<CovidProvider>(context, listen: false)
        .getReportByCountry(coutryCodes[_index]);
    setState(() {
      _cases =
          Provider.of<CovidProvider>(context, listen: false).casesByCountry;
      _deaths =
          Provider.of<CovidProvider>(context, listen: false).deathsByCountry;
      _recovered =
          Provider.of<CovidProvider>(context, listen: false).recoveredByCountry;
    });
    _generateData();
    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    final formatter = new NumberFormat("#,###");
    return Scaffold(
      backgroundColor: Color(0xFF21BFBD),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 35.0, left: 10.0),
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: 80,
                          ),
                          Container(
                            width: 250,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: SearchableDropdown.single(
                              items: _dropdownMenuItems,
                              value: _selectedCountry,
                              hint: "Select one",
                              searchHint: "Select one",
                              onChanged: (value) {
                                changeDropdownItem(value);
                              },
                              isExpanded: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 70.0,
                    ),
                    Center(
                      child: Container(
                        width: 100,
                        height: 50,
                        child: ClipRRect(
                          child: SvgPicture.network(
                            _flagUrl,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: _selectedCountry.length > 25
                          ? Text(
                              _selectedCountry.substring(0, 24) + '...',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 28.0),
                            )
                          : Text(
                              _selectedCountry,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 28.0),
                            ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.only(topLeft: Radius.circular(75.0)),
                      ),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 45.0),
                            child: Container(
                              child: Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  UserData(
                                    icon: Icons.perm_identity,
                                    text: _selectedLanguage == 'Amharic'
                                        ? formatter.format(_cases) +
                                            '  በበሽታው የተያዙ'
                                        : formatter.format(_cases) + '  Cases',
                                  ),
                                  UserData(
                                    icon: Icons.mood_bad,
                                    text: _selectedLanguage == 'Amharic'
                                        ? formatter.format(_deaths) +
                                            '  በበሽታው የሞቱ'
                                        : formatter.format(_deaths) +
                                            '  Deaths',
                                  ),
                                  UserData(
                                    icon: Icons.mood,
                                    text: _selectedLanguage == 'Amharic'
                                        ? formatter.format(_recovered) +
                                            '  ከበሽታው ያገገሙ'
                                        : formatter.format(_recovered) +
                                            '  Recovered',
                                  ),

                                  //pie chart 2
                                  Provider.of<CovidProvider>(context).showChart
                                      ? Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Container(
                                            height: 300,
                                            child: Center(
                                              child: Column(
                                                children: <Widget>[
                                                  Text(
                                                    _selectedLanguage ==
                                                            'Amharic'
                                                        ? 'ኮቪድ-19 ሪፖርት'
                                                        : 'Covid-19 Report',
                                                    style: TextStyle(
                                                      fontSize: 24.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10.0,
                                                  ),
                                                  Expanded(
                                                    child: charts.PieChart(
                                                      _seriesPieData,
                                                      animate: true,
                                                      animationDuration:
                                                          Duration(seconds: 3),
                                                      behaviors: [
                                                        new charts.DatumLegend(
                                                            outsideJustification:
                                                                charts
                                                                    .OutsideJustification
                                                                    .endDrawArea,
                                                            horizontalFirst:
                                                                false,
                                                            desiredMaxRows: 2,
                                                            cellPadding:
                                                                new EdgeInsets
                                                                        .only(
                                                                    right: 4.0,
                                                                    bottom:
                                                                        4.0),
                                                            entryTextStyle: charts
                                                                .TextStyleSpec(
                                                              color: charts
                                                                  .MaterialPalette
                                                                  .purple
                                                                  .shadeDefault,
                                                              fontFamily:
                                                                  'Georgia',
                                                              fontSize: 11,
                                                            ))
                                                      ],
                                                      defaultRenderer: new charts
                                                              .ArcRendererConfig(
                                                          arcWidth: 100,
                                                          arcRendererDecorators: [
                                                            new charts
                                                                    .ArcLabelDecorator(
                                                                labelPosition:
                                                                    charts
                                                                        .ArcLabelPosition
                                                                        .inside)
                                                          ]),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container(
                                          height: 300.0,
                                        ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
      //),
    );
  }
}
