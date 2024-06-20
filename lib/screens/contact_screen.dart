import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/covid_provider.dart';
import '../widgets/contacts.dart';

class ContactScreen extends StatefulWidget {
  static String routeName = 'contact';

  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  String _selectedLanguage;
  bool _isLoading = false;

  @override
  void didChangeDependencies() async {
    _isLoading = true;
    await Provider.of<CovidProvider>(context, listen: false).getLanguage();
    setState(() {
      _selectedLanguage =
          Provider.of<CovidProvider>(context, listen: false).language;
    });
    _isLoading = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedLanguage == 'Amharic' ? 'የስልክ መስመሮች' : 'Contacts',
        ),
        backgroundColor: Color.fromRGBO(178, 102, 255, 1),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 20.0,
                  ),
                  _selectedLanguage == 'Amharic'
                      ? StateContact(
                          'አዲስ አበባ', '8335/952', 'assets/images/aa.png')
                      : StateContact(
                          'Addis Ababa', '8335/952', 'assets/images/aa.png'),
                  _selectedLanguage == 'Amharic'
                      ? StateContact('አፋር', '6220', 'assets/images/afar.png')
                      : StateContact('Afar', '6220', 'assets/images/afar.png'),
                  _selectedLanguage == 'Amharic'
                      ? StateContact('አማራ', '6981', 'assets/images/amhara.png')
                      : StateContact(
                          'Amhara', '6981', 'assets/images/amhara.png'),
                  _selectedLanguage == 'Amharic'
                      ? StateContact(
                          'ቤኒሻንጉል ጉሙዝ', '6016', 'assets/images/bg.png')
                      : StateContact(
                          'Benishangul G.', '6016', 'assets/images/bg.png'),
                  _selectedLanguage == 'Amharic'
                      ? StateContact('ድሬዳዋ', '6407', 'assets/images/dire.png')
                      : StateContact(
                          'Dire Dawa', '6407', 'assets/images/dire.png'),
                  _selectedLanguage == 'Amharic'
                      ? StateContact(
                          'ጋምቤላ', '6184', 'assets/images/gambela.png')
                      : StateContact(
                          'Gambela', '6184', 'assets/images/gambela.png'),
                  _selectedLanguage == 'Amharic'
                      ? StateContact('ሀረሪ', '6864', 'assets/images/harar.png')
                      : StateContact(
                          'Harari', '6864', 'assets/images/harar.png'),
                  _selectedLanguage == 'Amharic'
                      ? StateContact(
                          'ኦሮሚያ', '6955', 'assets/images/oromiya.png')
                      : StateContact(
                          'Oromiya', '6955', 'assets/images/oromiya.png'),
                  _selectedLanguage == 'Amharic'
                      ? StateContact('ሱማሌ', '6599', 'assets/images/somali.jpeg')
                      : StateContact(
                          'Somali', '6599', 'assets/images/somali.jpeg'),
                  _selectedLanguage == 'Amharic'
                      ? StateContact(
                          'ደቡብ ክልል', '6929', 'assets/images/snnp.png')
                      : StateContact(
                          'Southern NNP', '6929', 'assets/images/snnp.png'),
                  _selectedLanguage == 'Amharic'
                      ? StateContact('ትግራይ', '6244', 'assets/images/tigray.png')
                      : StateContact(
                          'Tigray', '6244', 'assets/images/tigray.png'),
                ],
              ),
            ),
    );
  }
}
