import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';
import 'dart:math' as math;

import 'camera.dart';
import 'bndbox.dart';


class HomePage extends StatefulWidget {
  final List<CameraDescription> cameras;

  HomePage(this.cameras);

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> _recognitions;
  int _imageHeight = 0;
  int _imageWidth = 0;
  String _model = "";

  @override
  void initState() {
    super.initState();
  }

  loadModel() async {
    String res;
    switch (_model) {
      case "Tiny YOLOv2":
        res = await Tflite.loadModel(
          model: "assets/yolov2_tiny.tflite",
          labels: "assets/yolov2_tiny.txt",
        );
        break;

      case "SSD MobileNet":
        res = await Tflite.loadModel(
            model: "assets/ssd_mobilenet.tflite",
            labels: "assets/ssd_mobilenet.txt");
    }
    //print(res);
  }

  onSelect(model) {
    print("onselect");
    setState(() {
      _model = "";
      _model = model;
      print(_model);
    });
    loadModel();
  }

  setRecognitions(recognitions, imageHeight, imageWidth) {
    setState(() {
      _recognitions = recognitions;
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
      appBar:AppBar(
        title: Text('Object Detection'),
        leading:
        IconButton(onPressed: ()=>onSelect(""), icon: Icon(Icons.arrow_back)),


        actions: [
          TextButton(onPressed:()=>onSelect("SSD MobileNet"), child:Text('SSD')),
          TextButton(onPressed:()=>onSelect("Tiny YOLOv2"), child:Text('YOLO')),
        ],
      ),
      body:
      _model == ""
          ? Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:[Text("원하는 모델을 선택해주세요", style: TextStyle(fontSize: 20, color: Colors.white))]
        ),



              // child: Column(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: <Widget>[
              //     RaisedButton(
              //       child: const Text("SSD MobileNet"), //SSD mobilenet
              //       onPressed: () => onSelect("SSD MobileNet"),
              //     ),
              //     RaisedButton(
              //       child: const Text("Tiny YOLOv2"),//yolo
              //       onPressed: () => onSelect("Tiny YOLOv2"),
              //     ),
              //   ],
              // ),
            )
          :
      Stack(
              children: [
                Camera(
                  widget.cameras,
                  _model,
                  setRecognitions,
                ),
                BndBox(
                    _recognitions == null ? [] : _recognitions,
                    math.max(_imageHeight, _imageWidth),
                    math.min(_imageHeight, _imageWidth),
                    screen.height,
                    screen.width,
                    _model ),
              ],
            ),
    );
  }
}
