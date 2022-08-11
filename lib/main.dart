import 'package:clone_pinterest/pages/detail_page.dart';
import 'package:clone_pinterest/pages/home_page.dart';
import 'package:clone_pinterest/pages/search_page.dart';
import 'package:flutter/material.dart';
void main(){
  runApp(MyApp());

  print("1");
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      routes: {
        HomePage.id:(context) =>HomePage(),
        DetailsPage.id: (context) => DetailsPage(),
        SearchPage.id: (context)=> SearchPage()

      },
    );
  }
}
