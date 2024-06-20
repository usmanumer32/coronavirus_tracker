import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/covid_provider.dart';
import '../widgets/info_card.dart';
import '../models/sort_countries.dart';
import '../widgets/country_report.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = 'home';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _init = true;
  int cases;
  int suspected;
  int confirmed;
  int death;
  String updated;
  int recovered = 0;
  String _selectedLanguage = 'English';
  var _isLoading = false;
  List<SortCountries> _sortedCountries = [];
  List<DropdownMenuItem<String>> _dropdownMenuItems = [
    DropdownMenuItem<String>(
      child: Text(
        'English',
        overflow: TextOverflow.ellipsis,
      ),
      value: 'English',
    ),
    DropdownMenuItem<String>(
      child: Text(
        'አማርኛ',
        overflow: TextOverflow.ellipsis,
      ),
      value: 'Amharic',
    ),
  ];

  GlobalKey<RefreshIndicatorState> refreshKey;

  @override
  void initState() {
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
  }

  @override
  void didChangeDependencies() async {
    if (_init) {
      setState(() {
        callAllFunctions();
      });
      await Provider.of<CovidProvider>(context, listen: false).getLanguage();
      var language =
          Provider.of<CovidProvider>(context, listen: false).language;
      for (int i = 0; i < _dropdownMenuItems.length; i++) {
        if (language == _dropdownMenuItems[i].value) {
          setState(() {
            _selectedLanguage = _dropdownMenuItems[i].value;
          });
        }
      }
    }
    _init = false;
    super.didChangeDependencies();
  }

  Future<void> callAllFunctions() async {
    _isLoading = true;
    await Provider.of<CovidProvider>(context, listen: false)
        .getCasesByCountry();
    await Provider.of<CovidProvider>(context, listen: false).getReport();
    setState(() {
      cases = Provider.of<CovidProvider>(context, listen: false).cases;
      death = Provider.of<CovidProvider>(context, listen: false).deaths;
      recovered = Provider.of<CovidProvider>(context, listen: false).recovered;
      updated = Provider.of<CovidProvider>(context, listen: false).updated;
      _sortedCountries = Provider.of<CovidProvider>(context, listen: false)
          .sortedCasesByCountry;
    });
    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    void changeLanguage(String selectedLanguage) async {
      await Provider.of<CovidProvider>(context, listen: false)
          .setLanguage(selectedLanguage);
      await Provider.of<CovidProvider>(context, listen: false).getLanguage();
      setState(() {
        _selectedLanguage =
            Provider.of<CovidProvider>(context, listen: false).language;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Covid-19 Tracker'),
        backgroundColor: Color.fromRGBO(178, 102, 255, 1),
        actions: <Widget>[
          Container(
            width: 100,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: DropdownButton<String>(
              //iconEnabledColor: Colors.white,
              isExpanded: true,
              //style: TextStyle(inherit: false,color: Colors.white, ),
              items: _dropdownMenuItems,
              value: _selectedLanguage,
              onChanged: (value) {
                changeLanguage(value);
              },
            ),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              key: refreshKey,
              onRefresh: callAllFunctions,
              child: SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 20.0),
                        width: double.infinity,
                        child: Center(
                          child: DateTime.parse(updated).day ==
                                  DateTime.now().day
                              ? Text(
                                  _selectedLanguage == 'Amharic'
                                      ? 'መጨረሻ የታደሰው  ' +
                                          DateFormat('kk:mm:a').format(
                                            DateTime.parse(updated),
                                          )
                                      : 'Last Updated  ' +
                                          DateFormat('kk:mm:a').format(
                                            DateTime.parse(updated),
                                          ),
                                )
                              : Text(
                                  _selectedLanguage == 'Amharic'
                                      ? 'መጨረሻ የታደሰው  ' +
                                          DateFormat.yMEd().add_jms().format(
                                                DateTime.parse(updated),
                                              )
                                      : 'Last Updated  ' +
                                          DateFormat.yMEd().add_jms().format(
                                                DateTime.parse(updated),
                                              ),
                                ),
                        ),
                      ),
                      InfoCard(
                        color: Color.fromRGBO(102, 178, 255, 1),
                        imgUrl: 'assets/images/cases.png',
                        amount: cases,
                        text: _selectedLanguage == 'Amharic'
                            ? 'በበሽታው የተያዙ'
                            : 'Cases',
                        textColor: Colors.white,
                      ),
                      InfoCard(
                        color: Colors.red[400],
                        imgUrl: 'assets/images/death.png',
                        amount: death,
                        text: _selectedLanguage == 'Amharic'
                            ? 'በበሽታው የሞቱ'
                            : 'Deaths',
                        textColor: Colors.white,
                      ),
                      InfoCard(
                        color: Colors.greenAccent,
                        imgUrl: 'assets/images/recovered.png',
                        amount: recovered,
                        text: _selectedLanguage == 'Amharic'
                            ? 'ከበሽታው ያገገሙ'
                            : 'Recovered',
                        textColor: Colors.white,
                      ),
                      SizedBox(
                        height: 25.0,
                      ),
                      Padding(
                        padding: EdgeInsets.all(12),
                        child: Material(
                          elevation: 18.0,
                          borderRadius: BorderRadius.circular(24.0),
                          shadowColor: Color(0x802196F3),
                          child: Container(
                            width: double.infinity,
                            height: 320.0,
                            child: Column(
                              children: <Widget>[
                                Text(
                                  _selectedLanguage == 'Amharic'
                                      ? 'ብዙ ሰው በበሽታው የተያዘባቸው 5 ሀገራት'
                                      : 'Confirmed Cases By Country (Top 5)',
                                  style: TextStyle(
                                      fontSize: 18.0, color: Colors.black54),
                                ),
                                SizedBox(
                                  height: 25.0,
                                ),
                                CountryData(_sortedCountries[0].name,
                                    _sortedCountries[0].cases),
                                CountryData(_sortedCountries[1].name,
                                    _sortedCountries[1].cases),
                                CountryData(_sortedCountries[2].name,
                                    _sortedCountries[2].cases),
                                CountryData(_sortedCountries[3].name,
                                    _sortedCountries[3].cases),
                                CountryData(_sortedCountries[4].name,
                                    _sortedCountries[4].cases),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
