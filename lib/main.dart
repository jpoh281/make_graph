import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:make_graph/bar.dart';
import 'package:make_graph/bar_bottom.dart';

void main() {
  runApp(MyApp());
}

Size? size;
double barWidth = 80;
double bottomHeight = 50;
double barHeight = 150;
int nowIndex = 0;
ScrollController scrollController = ScrollController();
bool scrollLock = false;
bool isScrolling = false;

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GraphPage(),
    );
  }
}

class GraphPage extends StatefulWidget {
  @override
  _GraphPageState createState() => _GraphPageState();
}

class _GraphPageState extends State<GraphPage> {
  late List<Widget> bars;
  @override
  initState() {
    super.initState();
    bars = List.generate(
        30, (index) => GraphItem(value: Random().nextInt(100).toDouble()));
  }


  int shortestBar(double now){
    double index = now / 80;

    int left = index.round();
    return left;
  }

  @override
  Widget build(BuildContext context) {
    if (size == null) size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
          body: NotificationListener<ScrollNotification>(
            onNotification: (scrollNotification){
              if(scrollNotification is ScrollStartNotification){
                isScrolling = true;
              }
              else if(scrollNotification is ScrollUpdateNotification){

                int left = shortestBar(
                    scrollNotification.metrics.extentBefore);
                  if(nowIndex != left){
                    HapticFeedback.heavyImpact();
                    nowIndex = left;
                  }
              }
              else if(scrollNotification is ScrollEndNotification) {
                if(!scrollLock) {
                  scrollLock = true;
                  int left = shortestBar(
                      scrollNotification.metrics.extentBefore);

                    nowIndex = left;
                  scrollController.jumpTo(left * 80.0);
                  HapticFeedback.heavyImpact();
                  scrollLock = false;
                }
                isScrolling = false;
              }
              return false;
            },
            child: SingleChildScrollView(
                dragStartBehavior: DragStartBehavior.start,
                controller: scrollController,
                scrollDirection: Axis.horizontal,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Row(
                      children: [
                        Container(width: size!.width / 2 - barWidth / 2),
                        ...List.generate(
                            30,
                            (index) => GraphItem(
                                value: Random().nextInt(100).toDouble(), index:index)),
                        Container(width: size!.width / 2 - barWidth / 2)
                      ],
                    );
                  },
                )),
          )),
    );
  }
}

class GraphItem extends StatelessWidget {

  final value;
  final index;
  const GraphItem({Key? key, this.value, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (_){
        if(!isScrolling){
          scrollController.jumpTo(index * 80.0);
          nowIndex = index;
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Bar(value : value,index: index,),
          BarBottom(index: index,)
        ],
      ),
    );
  }
}




