import 'package:flutter/material.dart';
import 'package:flutter_skribble_app/create_room_screen.dart';
import 'package:flutter_skribble_app/join_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Create/Join a room to play",
            style: TextStyle(fontSize: 24, color: Colors.black),
          ),
          SizedBox(
            height: height * 0.1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.blue),
                      textStyle: WidgetStateProperty.all(const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                      minimumSize:
                          WidgetStateProperty.all(Size(width / 2.5, 50))),
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const CreateRoomScreen())),
                  child: const Text(
                    "Create",
                  )),
              SizedBox(
                width: width * 0.1,
              ),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.blue),
                      textStyle: WidgetStateProperty.all(const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                      minimumSize:
                          WidgetStateProperty.all(Size(width / 2.5, 50))),
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const JoinRoomScreen())),
                  child: const Text(
                    "Join",
                  ))
            ],
          )
        ],
      )),
    );
  }
}
