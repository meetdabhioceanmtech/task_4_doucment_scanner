import 'package:document_scanner/pages/custom_page.dart';
import 'package:document_scanner/pages/from_gallery_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

final GlobalKey<ScaffoldMessengerState> snackbarKey = GlobalKey<ScaffoldMessengerState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        scaffoldMessengerKey: snackbarKey,
        theme: ThemeData.light().copyWith(
          primaryColor: const Color(0XFF084277),
        ),
        title: 'Flutter Document Scanner',
        home: const HomeScreen());
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // * Basic example page
            // ElevatedButton(
            //   onPressed: () => Navigator.push<void>(
            //     context,
            //     MaterialPageRoute(
            //       builder: (BuildContext context) => const BasicPage(),
            //     ),
            //   ),
            //   child: const Text(
            //     'Basic example',
            //   ),
            // ),

            // * Custom example page
            ElevatedButton(
              onPressed: () => Navigator.push<void>(
                context,
                MaterialPageRoute(
                  builder: (context) => const CustomPage(),
                ),
              ),
              child: const Text(
                'From camera example',
              ),
            ),

            // * From gallery example page
            ElevatedButton(
              onPressed: () => Navigator.push<void>(
                context,
                MaterialPageRoute(
                  builder: (context) => const FromGalleryPage(),
                ),
              ),
              child: const Text(
                'From gallery example',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
