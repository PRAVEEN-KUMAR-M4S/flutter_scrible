import 'package:flutter/material.dart';
import 'package:flutter_skribble_app/paint_screen.dart';
import 'package:flutter_skribble_app/widgets/custom_text_field.dart';

class JoinRoomScreen extends StatefulWidget {
  const JoinRoomScreen({super.key});

  @override
  State<JoinRoomScreen> createState() => _JoinRoomScreenState();
}

class _JoinRoomScreenState extends State<JoinRoomScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController roomController = TextEditingController();

  void joinRoom() {
    if (nameController.text.isNotEmpty && roomController.text.isNotEmpty) {
      Map<String, String> data = {
        'nickname': nameController.text,
        'name': roomController.text
      };
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PaintScreen(
                data: data,
                screenFrom: 'join-game',
              )));
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Join Room",
            style: TextStyle(fontSize: 30, color: Colors.black),
          ),
          SizedBox(
            height: height * 0.08,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomTextField(
                controller: nameController, hintText: "Enter your name"),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomTextField(
                controller: roomController, hintText: "Enter room name"),
          ),
          const SizedBox(
            height: 40,
          ),
          ElevatedButton(
              onPressed: joinRoom,
              style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.blue),
                  textStyle: WidgetStateProperty.all(const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
                  minimumSize: WidgetStateProperty.all(Size(width / 2.5, 50))),
              child: const Text(
                "Join Room",
                style: TextStyle(fontSize: 16, color: Colors.black),
              ))
        ],
      ),
    );
  }
}
