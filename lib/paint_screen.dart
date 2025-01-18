import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_skribble_app/models/custom_paint_screen.dart';
import 'package:flutter_skribble_app/models/touch_points.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class PaintScreen extends StatefulWidget {
  final Map<String, String> data;
  final String screenFrom;
  const PaintScreen({super.key, required this.data, required this.screenFrom});

  @override
  State<PaintScreen> createState() => _PaintScreenState();
}

class _PaintScreenState extends State<PaintScreen> {
  late IO.Socket _socket;
  Map dataOfRoom = {};
  List<TouchPoints> points = [];
  StrokeCap strokeType = StrokeCap.round;
  Color selectedColor = Colors.black;
  double opacity = 1;
  double strokeWidth = 2;

  @override
  void initState() {
    connect();
    print(widget.data);
    super.initState();
  }

  void connect() {
    _socket = IO.io("http://192.168.1.36:3000", <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    if (widget.screenFrom == 'createRoom') {
      _socket.emit('create-game', widget.data);
    } else {
      _socket.emit('join-game', widget.data);
    }
    _socket.connect();

    _socket.onConnect((data) {
      print("connected");
      _socket.on('updateRoom', (roomData) {
        setState(() {
          dataOfRoom = roomData;
        });

        if (roomData['isJoin'] != true) {}
      });

      _socket.on('points', (point) {
        if (point['details'] != null) {
          setState(() {
            points.add(TouchPoints(
                paint: Paint()
                  ..strokeCap = strokeType
                  ..isAntiAlias = true
                  ..color.withOpacity(opacity)
                  ..strokeWidth = strokeWidth,
                points: Offset((point['details']['dx']).toDouble(),
                    (point['details']['dy']).toDouble())));
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    void selectColor() {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Choose color'),
                content: SingleChildScrollView(
                  child: BlockPicker(
                      pickerColor: selectedColor,
                      onColorChanged: (color) {
                        String colorString = color.toString();
                        String valueString =
                            colorString.split('(0x')[1].split(')')[0];
                      }),
                ),
              ));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                width: width,
                height: height * 0.55,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    print(details.localPosition.dx);
                    _socket.emit('paint', {
                      'details': {
                        'dx': details.localPosition.dx,
                        'dy': details.localPosition.dy
                      },
                      'roomName': widget.data['name']
                    });
                  },
                  onPanStart: (details) {
                    print(details.localPosition.dx);
                    _socket.emit('paint', {
                      'details': {
                        'dx': details.localPosition.dx,
                        'dy': details.localPosition.dy
                      },
                      'roomName': widget.data['name']
                    });
                  },
                  onPanEnd: (details) {
                    print(details.localPosition.dx);
                    _socket.emit('paint',
                        {'details': null, 'roomName': widget.data['name']});
                  },
                  child: SizedBox.expand(
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      child: RepaintBoundary(
                        child: CustomPaint(
                          size: Size.infinite,
                          painter: MyCustomPainter(pointList: points),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.color_lens,
                        color: selectedColor,
                      )),
                  Expanded(
                      child: Slider(
                    value: strokeWidth,
                    min: 1.0,
                    max: 10,
                    label: "Stroke Width $strokeWidth",
                    activeColor: selectedColor,
                    onChanged: (double value) {},
                  )),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.layers_clear,
                        color: selectedColor,
                      )),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
