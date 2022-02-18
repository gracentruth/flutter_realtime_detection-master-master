import 'package:flutter/material.dart';
import 'dart:math' as math;


class BndBox extends StatefulWidget{
  final List<dynamic> results;
  final int previewH;
  final int previewW;
  final double screenH;
  final double screenW;
  final String model;

  BndBox(this.results, this.previewH, this.previewW, this.screenH, this.screenW,
      this.model);

  @override
  State<BndBox> createState() => _BndBoxState();
}

class _BndBoxState extends State<BndBox> {
  var _x;

  var _w =0.0;

  var _y ;

  var _h =0.0;

  Widget texting(){
    print("_w"+_w.toString());
    if(_w> 300 || _h>300){
      print('hi');
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children:[Text("Warning", style: TextStyle(fontSize: 50, color: Colors.red), )]
        ),
      );
    }
    else return Container();
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> _renderBoxes() {
      return widget.results.map((re) {
          _x = re["rect"]["x"];
          _w = re["rect"]["w"];
          _y = re["rect"]["y"];
          _h = re["rect"]["h"];


        var scaleW, scaleH, x, y, w, h;

        if (widget.screenH / widget.screenW > widget.previewH / widget.previewW) {
          scaleW = widget.screenH / widget.previewH * widget.previewW;
          scaleH = widget.screenH;
          var difW = (scaleW - widget.screenW) / scaleW;
          x = (_x - difW / 2) * scaleW;
          w = _w * scaleW;
          if (_x < difW / 2) w -= (difW / 2 - _x) * scaleW;
          y = _y * scaleH;
          h = _h * scaleH;
          setState(() {
            _w = w;
            _h = h;
          });
          print("WWWWWW" + _w.toString());

        } else {
          scaleH = widget.screenW / widget.previewW * widget.previewH;
          scaleW = widget.screenW;
          var difH = (scaleH - widget.screenH) / scaleH;
          x = _x * scaleW;
          w = _w * scaleW;
          y = (_y - difH / 2) * scaleH;
          h = _h * scaleH;
          if (_y < difH / 2) h -= (difH / 2 - _y) * scaleH;
          setState(() {
            _w = w;
            _h = h;
          });
        }


        print('bound');
        return Positioned(
          left: math.max(0, x),
          top: math.max(0, y),
          width: w,
          height: h,
          child: Container(
            padding: EdgeInsets.only(top: 5.0, left: 5.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: re["detectedClass"]=='person'?Color.fromRGBO(255, 0, 0, 1.0):Color.fromRGBO(0, 255, 0, 1.0),
                width: 3.0,
              ),
            ),
            child: Text(
            "${re["detectedClass"]} ${(re["confidenceInClass"] * 100).toStringAsFixed(0)}%",
              style: TextStyle(

                color: re["detectedClass"]=='person'?Color.fromRGBO(255, 0, 0, 1.0):Color.fromRGBO(0, 255, 0, 1.0),
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }).toList();
    }

    // List<Widget> _renderStrings() {
    //   double offset = -10;
    //   return results.map((re) {
    //     offset = offset + 14;
    //     return Positioned(
    //       left: 10,
    //       top: offset,
    //       width: screenW,
    //       height: screenH,
    //       child: Text(
    //         "${re["label"]} ${(re["confidence"] * 100).toStringAsFixed(0)}%",
    //         style: TextStyle(
    //           color: Color.fromRGBO(37, 213, 253, 1.0),
    //           fontSize: 14.0,
    //           fontWeight: FontWeight.bold,
    //         ),
    //       ),
    //     );
    //   }).toList();
    // }

    // List<Widget> _renderKeypoints() {
    //   var lists = <Widget>[];
    //   results.forEach((re) {
    //     var list = re["keypoints"].values.map<Widget>((k) {
    //       var _x = k["x"];
    //       var _y = k["y"];
    //       var scaleW, scaleH, x, y;
    //
    //       if (screenH / screenW > previewH / previewW) {
    //         scaleW = screenH / previewH * previewW;
    //         scaleH = screenH;
    //         var difW = (scaleW - screenW) / scaleW;
    //         x = (_x - difW / 2) * scaleW;
    //         y = _y * scaleH;
    //       } else {
    //         scaleH = screenW / previewW * previewH;
    //         scaleW = screenW;
    //         var difH = (scaleH - screenH) / scaleH;
    //         x = _x * scaleW;
    //         y = (_y - difH / 2) * scaleH;
    //       }
    //       return Positioned(
    //         left: x - 6,
    //         top: y - 6,
    //         width: 100,
    //         height: 12,
    //         child: Container(
    //           child: Text(
    //             "● ${k["part"]}",
    //             style: TextStyle(
    //               color: Color.fromRGBO(37, 213, 253, 1.0),
    //               fontSize: 12.0,
    //             ),
    //           ),
    //         ),
    //       );
    //     }).toList();
    //
    //     lists..addAll(list);
    //   });
    //
    //   return lists;
    // }

    return Container(
      //child:texting(),
      child:Stack(
        children:[
          texting(),
          Stack(
            children: _renderBoxes(),
          ),
        ],

      )
    );
  }
}
