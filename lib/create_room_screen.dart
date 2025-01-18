import 'package:flutter/material.dart';
import 'package:flutter_skribble_app/paint_screen.dart';
import 'package:flutter_skribble_app/widgets/custom_text_field.dart';

class CreateRoomScreen extends StatefulWidget {
  const CreateRoomScreen({super.key});

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController roomController = TextEditingController();
  late String? _maxRound;
  late String? _roomSize;

  void createRoom() {
    if (nameController.text.isNotEmpty &&
        roomController.text.isNotEmpty &&
        _maxRound != null &&
        _roomSize != null) {
      Map<String, String> data = {
        'nickname': nameController.text,
        'name': roomController.text,
        'occupancy': _roomSize!,
        'maxRound': _maxRound!
      };
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PaintScreen(
                data: data,
                screenFrom: 'createRoom',
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
            "Create Room",
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
            height: 20,
          ),
          DropdownButton<String>(
            focusColor: const Color(0xffF5F5FA),
            items: <String>["2", "5", "10", "15"]
                .map<DropdownMenuItem<String>>(
                  (String e) => DropdownMenuItem(
                    value: e,
                    child: Text(
                      e,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                )
                .toList(),
            hint: const Text(
              "Select Max Rounds",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontSize: 14),
            ),
            onChanged: (String? value) {
              setState(() {
                _maxRound = value;
              });
            }, // Convert Iterable to List
          ),
          const SizedBox(
            height: 20,
          ),
          DropdownButton<String>(
            focusColor: const Color(0xffF5F5FA),
            items: <String>["2", "3", "4", "5", "6", "7", "8", "9"]
                .map<DropdownMenuItem<String>>(
                  (String e) => DropdownMenuItem(
                    value: e,
                    child: Text(
                      e,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                )
                .toList(),
            hint: const Text(
              "Select Room Size",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontSize: 14),
            ),
            onChanged: (String? value) {
              setState(() {
                _roomSize = value;
              });
            }, // Convert Iterable to List
          ),
          const SizedBox(
            height: 40,
          ),
          ElevatedButton(
              onPressed: createRoom,
              style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.blue),
                  textStyle: WidgetStateProperty.all(const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
                  minimumSize: WidgetStateProperty.all(Size(width / 2.5, 50))),
              child: const Text(
                "Create Room",
                style: TextStyle(fontSize: 16, color: Colors.black),
              ))
        ],
      ),
    );
  }
}
