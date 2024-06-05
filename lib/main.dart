import 'package:flutter/material.dart';
import 'package:mad_mid/Registration.dart';
import 'package:mad_mid/login.dart';
import 'package:mad_mid/lastpage.dart';
import 'package:mad_mid/home.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      //home: const MyHomePage(title: 'Flutter Demo Home Page'),
      initialRoute: '/signup',
      routes: {
        '/signup':(BuildContext context) => const RegistrationScreen() ,
      },
    );
  }
}

