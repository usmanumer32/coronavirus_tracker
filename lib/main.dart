import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/covid_provider.dart';
import './screens/home_screen.dart';
import './screens/tabs_screen.dart';
import './screens/profile_screen.dart';
import './screens/info_screen.dart';
import './screens/contact_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: CovidProvider()),
      ],
      child: MaterialApp(
        title: 'CoronaVirus Tracker',
        debugShowCheckedModeBanner: false,
        //home: HomeScreen(),
        initialRoute: '/',
        routes: {
          '/': (ctx) => TabsScreen(),
          HomeScreen.routeName: (ctx) => HomeScreen(),
          Profile.routeName: (ctx) => Profile(),
          InfoScreen.routeName: (ctx) => InfoScreen(),
          ContactScreen.routeName: (ctx) => ContactScreen(),
        },
      ),
    );
  }
}
