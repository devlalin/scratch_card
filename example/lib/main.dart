import 'package:flutter/material.dart';
import 'package:scratch_card/scratch_card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        home: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 100,
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.amber,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: ScratchCard(
                      stockSize: 50,
                      imageType: ImageType.network,
                      scratchColor: Colors.pink,
                      child: Center(child: Text('Hi lalin success')),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
