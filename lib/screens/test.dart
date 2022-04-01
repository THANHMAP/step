import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({Key? key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<TestScreen> {
  bool _isDropped = false;
  Color _color = Colors.red;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        body: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              Draggable(
                data: Colors.red,
                child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.red,
                ),
                feedback: Container(
                  width: 100,
                  height: 100,
                  color: Colors.red,
                ),
                childWhenDragging: Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey,
                ),
              ),
              Spacer(),
              DragTarget(
                builder: (context, accepted, rejected) {
                  return Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(border: Border.all(),
                        color: _isDropped ? Colors.red : Colors.white),
                  );
                },
                onWillAccept: (data) {
                  return data == Colors.red;
                },
                onAccept: (data) {
                  setState(() {
                    _isDropped = true;
                  });
                },
              ),
              Spacer()
            ],
          ),

        ),
      ),
    );
  }
}
