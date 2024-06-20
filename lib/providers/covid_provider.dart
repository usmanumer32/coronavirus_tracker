import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/country.dart';
import '../models/piechart_data.dart';
import '../models/sort_countries.dart';

class CovidProvider with ChangeNotifier {
  int _cases;
  int _deaths;
  int _recovered;
  String _updated;
  List<Country> _countries = [];
  int _casesByCountry;
  int _deathsByCountry;
  int _recoveredByCountry;
  double _casesPercentage;
  double _deathsPercentage;
  double _recoveredPercentage;
  double _activePercentage;
  List<PieChartData> _pieData = [];
  bool _showChart = true;
  List<String> _sortedCountries = [];
  List<SortCountries> _sortedCasesByCountry = [];
  String _language;

  CovidProvider() {
    getLanguage();
    getCountries();
  }

  String get language {
    return _language;
  }

  Future<void> setLanguage(String language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', language);
    getLanguage();
    //notifyListeners();
  }

  Future<void> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    _language = prefs.getString('language');
    if (_language == null) {
      setLanguage('English');
    }
    notifyListeners();
  }

  bool get showChart {
    return _showChart;
  }

  int get cases {
    return _cases;
  }

  int get deaths {
    return _deaths;
  }

  int get recovered {
    return _recovered;
  }

  String get updated {
    return _updated;
  }

  List<Country> get countries {
    return [..._countries];
  }

  List<String> get countryNames {
    List<String> names = [];
    _countries.forEach((country) => names.add(country.name));
    return names;
  }

  List<String> get countryCodes {
    List<String> codes = [];
    _countries.forEach((country) => codes.add(country.code));
    return codes;
  }

  Future<void> getReport() async {
    var url = 'https://covid19.mathdro.id/api';
    final response = await http.get(url);
    _cases = json.decode(response.body)['confirmed']['value'];
    _deaths = json.decode(response.body)['deaths']['value'];
    _recovered = json.decode(response.body)['recovered']['value'];
    _updated = json.decode(response.body)['lastUpdate'];
    notifyListeners();
  }

  Future<void> getCountries() async {
    var url = 'https://restcountries.eu/rest/v2/all';
    final response = await http.get(url);
    var extractedData = json.decode(response.body);
    final List<Country> loadedCountries = [];
    extractedData.forEach(
      (e) => loadedCountries.add(
        Country(
          name: e['name'],
          flag: e['flag'],
          code: e['alpha2Code'],
        ),
      ),
    );
    _countries = loadedCountries;
  }

  Future<void> getReportByCountry(String country) async {
    var url = 'https://covid19.mathdro.id/api/countries/$country';
    final response = await http.get(url);
    if (response.statusCode == 200) {
      _casesByCountry = await json.decode(response.body)['confirmed']['value'];
      _deathsByCountry = await json.decode(response.body)['deaths']['value'];
      _recoveredByCountry =
          await json.decode(response.body)['recovered']['value'];
      _showChart = true;
      calculatePercentage();
    } else {
      _showChart = false;
      _casesByCountry = 0;
      _deathsByCountry = 0;
      _recoveredByCountry = 0;
    }
  }

  int get casesByCountry {
    return _casesByCountry;
  }

  int get deathsByCountry {
    return _deathsByCountry;
  }

  int get recoveredByCountry {
    return _recoveredByCountry;
  }

  void calculatePercentage() {
    _casesPercentage = (_casesByCountry * 100) / _casesByCountry;
    _casesPercentage = num.parse(_casesPercentage.toStringAsFixed(2));
    _deathsPercentage = (_deathsByCountry * 100) / _casesByCountry;
    _deathsPercentage = num.parse(_deathsPercentage.toStringAsFixed(2));
    _recoveredPercentage = (_recoveredByCountry * 100) / _casesByCountry;
    _recoveredPercentage = num.parse(_recoveredPercentage.toStringAsFixed(2));
    _activePercentage = 100 - _recoveredPercentage - _deathsPercentage;
    _activePercentage = num.parse(_activePercentage.toStringAsFixed(2));
    generatePieChartData();
  }

  void generatePieChartData() {
    if (_recoveredPercentage > 0 && _deathsPercentage == 0) {
      var pieData = [
        new PieChartData(
            title: language == 'Amharic'
                ? 'የተያዙ ' + _activePercentage.toString() + '%'
                : 'Active Cases ' + _activePercentage.toString() + '%',
            percentageValue: _activePercentage,
            colorValue: Colors.blueAccent),
        new PieChartData(
            title: language == 'Amharic'
                ? 'ያገገሙ ' + _recoveredPercentage.toString() + '%'
                : 'Recovered ' + _recoveredPercentage.toString() + '%',
            percentageValue: _recoveredPercentage,
            colorValue: Colors.greenAccent),
      ];
      _pieData = pieData;
    } else if (_recoveredPercentage == 0 && _deathsPercentage > 0) {
      var pieData = [
        new PieChartData(
          title: language == 'Amharic'
              ? 'የተያዙ ' + _activePercentage.toString() + '%'
              : 'Active Cases ' + _activePercentage.toString() + '%',
          percentageValue: _activePercentage,
          colorValue: Colors.blueAccent,
        ),
        new PieChartData(
          title: language == 'Amharic'
              ? 'ሞት ' + _deathsPercentage.toString() + '%'
              : 'Deaths ' + _deathsPercentage.toString() + '%',
          percentageValue: _deathsPercentage,
          colorValue: Colors.greenAccent,
        ),
      ];
      _pieData = pieData;
    } else if (_deathsPercentage > 0 && _recoveredPercentage > 0) {
      var pieData = [
        new PieChartData(
          title: language == 'Amharic'
              ? 'ሞት ' + _deathsPercentage.toString() + '%'
              : 'Deaths ' + _deathsPercentage.toString() + '%',
          percentageValue: _deathsPercentage,
          colorValue: Colors.redAccent,
        ),
        new PieChartData(
          title: language == 'Amharic'
              ? 'ያገገሙ ' + _recoveredPercentage.toString() + '%'
              : 'Recovered ' + _recoveredPercentage.toString() + '%',
          percentageValue: _recoveredPercentage,
          colorValue: Colors.greenAccent,
        ),
        new PieChartData(
          title: language == 'Amharic'
              ? 'የተያዙ ' + _activePercentage.toString() + '%'
              : 'Active Cases ' + _activePercentage.toString() + '%',
          percentageValue: _activePercentage,
          colorValue: Colors.blueAccent,
        ),
      ];
      _pieData = pieData;
    } else {
      var pieData = [
        new PieChartData(
            title: language == 'Amharic'
                ? 'የተያዙ ' + _activePercentage.toString() + '%'
                : 'Active Cases ' + _activePercentage.toString() + '%',
            percentageValue: _activePercentage,
            colorValue: Colors.blueAccent),
      ];
      _pieData = pieData;
    }
  }

  List<PieChartData> get pieData {
    return _pieData;
  }

  Future<void> getCasesByCountry() async {
    //var url = 'https://corona.lmao.ninja/countries?sort=cases';
    var url = 'https://corona.lmao.ninja/v2/countries?sort=cases';
    final response = await http.get(url);
    var extractedData = json.decode(response.body);
    final List<String> sortedCountries = [];
    for (int i = 0; i < 5; i++) {
      sortedCountries.add(extractedData[i]['country']);
    }
    _sortedCountries = sortedCountries;

    _sortedCasesByCountry = [];
    for (int i = 0; i < _sortedCountries.length; i++) {
      String country = _sortedCountries[i];
      var url = 'https://covid19.mathdro.id/api/countries/$country';
      final response = await http.get(url);
      _sortedCasesByCountry.add(
        SortCountries(
          name: country,
          cases: await json.decode(response.body)['confirmed']['value'],
        ),
      );
    }
  }

  List<String> get sortedCountries {
    return _sortedCountries;
  }

  List<SortCountries> get sortedCasesByCountry {
    return _sortedCasesByCountry;
  }
}
