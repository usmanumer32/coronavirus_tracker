import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/covid_provider.dart';
import '../widgets/card_info.dart';
import './contact_screen.dart';

class InfoScreen extends StatefulWidget {
  static String routeName = 'info';

  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
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
          _selectedLanguage == 'Amharic' ? 'መከላከያ መንገዶች' : 'Prevention Methods',
        ),
        backgroundColor: Color.fromRGBO(178, 102, 255, 1),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.phone),
            onPressed: () {
              Navigator.of(context).pushNamed(ContactScreen.routeName);
            },
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                child: Column(
                  children: <Widget>[
                    CardInformation(
                      imageUrl: 'assets/images/protect-wash-hands.png',
                      title: _selectedLanguage == 'Amharic'
                          ? 'እጅዎን በተደጋጋሚ ይታጠቡ'
                          : 'Clean your hands often',
                      description: _selectedLanguage == 'Amharic'
                          ? 'እጅዎን በሳሙና ቢያንስ ለ20 ሰከንድ ይታጠቡ ወይም ቢያንስ 60% አልኮል ባለው የእጅ ማፅጃ (ሳኒታይዘር) እጅዎን ያፅዱ።'
                          : 'Wash your hands often with soap and water for at least 20 seconds or use a hand sanitizer that contains at least 60% alcohol.',
                    ),
                    CardInformation(
                      imageUrl: 'assets/images/protect-quarantine.png',
                      title: _selectedLanguage == 'Amharic'
                          ? 'እርቀትዎን ይጠብቁ'
                          : 'Avoid close contact',
                      description: _selectedLanguage == 'Amharic'
                          ? 'የበሽታው ምልክት ከታየባቸውም ሆነ ከሌሎች ሰዎች ጋር የሚኖርን የቅርብ ግንኙነት ያስወግዱ። በመካከላችሁም በቂ ርቀትን ይጠብቁ።'
                          : 'Avoid close contact with people who are sick and Put distance between yourself and other people.',
                    ),
                    CardInformation(
                      imageUrl: 'assets/images/COVIDweb.png',
                      title: _selectedLanguage == 'Amharic'
                          ? 'የህመም ስሜት ከተሰማዎት በቤት ውስጥ ይቆዩ'
                          : 'Stay home if you’re sick',
                      description: _selectedLanguage == 'Amharic'
                          ? 'የህመም ስሜት ከተሰማዎት ከቤት አይውጡ። የጤና ሚኒስቴር ባዘጋጃቸው የስልክ ቁጥሮች ላይ በመደወል በመጀመርያ እርዳታ ይጠይቁ። '
                          : 'Stay home if you are sick, and call the numbers prepared by the Ministry of Health for medical help.',
                    ),
                    CardInformation(
                      imageUrl: 'assets/images/coverCough.png',
                      title: _selectedLanguage == 'Amharic'
                          ? 'በሚያስነጥስዎ ወይም በሚያስልዎ ወቅት አፍ እና አፍንጫዎትን ይሸፍኑ'
                          : 'Cover coughs and sneezes',
                      description: _selectedLanguage == 'Amharic'
                          ? 'በሚያስነጥስዎ ወይም በሚያስልዎ ወቅት አፍ እና አፍንጫዎትን በሶፍት ወይም በክርንዎ የውስጠኛው ክፍል ይሸፍኑ።'
                          : 'Cover your mouth and nose with a tissue when you cough or sneeze or use the inside of your elbow.',
                    ),
                    CardInformation(
                      imageUrl: 'assets/images/mask.png',
                      title: _selectedLanguage == 'Amharic'
                          ? 'የፊት መሸፈኛ ጭንብል (ማስክ) ይልበሱ'
                          : 'Wear a facemask if you are sick',
                      description: _selectedLanguage == 'Amharic'
                          ? 'በተለይ የህመም ስሜት ከተሰማዎት ወይም ሰዎች በሚበዙበት ቦታ ከሆኑ የፊት መሸፈኛ ጭንብል (ማስክ) ይልበሱ።'
                          : 'If you are sick: You should wear a facemask when you are around other people (e.g., sharing a room or vehicle)',
                    ),
                    CardInformation(
                      imageUrl: 'assets/images/clean.png',
                      title: _selectedLanguage == 'Amharic'
                          ? 'የግል እና የአካባቢዎን ንፅህና ይጠብቁ'
                          : 'Clean and disinfect',
                      description: _selectedLanguage == 'Amharic'
                          ? 'ሰዎች በተደጋጋሚ ሊነኳቸው የሚችሉ ቦታዎችን ያፅዱ። ለምሳሌ ጠረዼዛ፣ የበር እጀታ፣ ስልክ፣ የኮምፒውተር ኪቦርድ እና የመፀዳጃ ቤት እቃዎችን በተገቢ ሁኔታ ያፅዱ።'
                          : 'Clean and disinfect frequently touched surfaces daily. This includes tables, doorknobs, desks, phones, keyboards, and toilets',
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
