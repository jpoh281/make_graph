import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:make_graph/bar.dart';
import 'package:make_graph/bar_bottom.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

final pointIndexProvider = StateProvider<int>((ref) {
  return 0;
});

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

class GraphPage extends ConsumerStatefulWidget {
  @override
  _GraphPageState createState() => _GraphPageState();
}

class _GraphPageState extends ConsumerState<GraphPage> {
  late List<Widget> bars;

  @override
  initState() {
    super.initState();
    bars = List.generate(
        3000, (index) => GraphItem(value: Random().nextInt(100).toDouble()));
  }

  int shortestBar(double now) {
    double index = now / 80;

    int left = index.round();
    return left;
  }

  @override
  Widget build(BuildContext context) {
    if (size == null) size = MediaQuery.of(context).size;

    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 300,
                child: NotificationListener<ScrollNotification>(
                  onNotification: (scrollNotification) {
                    if (scrollNotification is ScrollStartNotification) {
                      isScrolling = true;
                    } else if (scrollNotification is ScrollUpdateNotification) {
                      int left = shortestBar(scrollNotification.metrics.extentBefore);
                      if (ref.read(pointIndexProvider).state != left) {
                        ref.read(pointIndexProvider).state = left;
                        HapticFeedback.heavyImpact();
                        print("update : $left");
                      }
                    } else if (scrollNotification is ScrollEndNotification) {
                      if (!scrollLock) {
                        scrollLock = true;
                        int left =
                            shortestBar(scrollNotification.metrics.extentBefore);

                        ref.read(pointIndexProvider).state = left;
                        print(nowIndex);
                        scrollController.jumpTo(left * 80.0);
                        HapticFeedback.heavyImpact();
                        scrollLock = false;
                        print("end : $left");
                      }
                      isScrolling = false;
                    }
                    return false;
                  },
                  child: SingleChildScrollView(
                      dragStartBehavior: DragStartBehavior.down,
                      controller: scrollController,
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Container(width: size!.width / 2 - barWidth / 2),
                          ListView.builder(
                            primary: false,
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return GraphItem(
                                  value: Random().nextInt(100).toDouble(),
                                  index: index);
                            },
                            itemCount: 3000,
                          ),
                          // ...List.generate(
                          //     1500,
                          //     (index) => GraphItem(
                          //         value: Random().nextInt(100).toDouble(), index:index)),
                          Container(width: size!.width / 2 - barWidth / 2)
                        ],
                      )),
                ),
              ),
              Container(
                height: 300,
                color: Colors.black,
              ),
              Container(
                height: 300,
                color: Colors.yellow,
              ),
              Container(
                height: 300,
                color: Colors.green,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class GraphItem extends ConsumerWidget {
  final value;
  final index;

  const GraphItem({Key? key, this.value, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isPointed = ref.watch(pointIndexProvider.select((value) {
      return value.state == index ? true : false;
    }));
    print("$index : $isPointed");
    return GestureDetector(
      onTapUp: (_) {
        if (!isScrolling) {
          scrollController.jumpTo(index * 80.0);
          nowIndex = index;
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Bar(
            value: value,
            index: index,
            isPointed: isPointed,
          ),
          BarBottom(
            index: index,
            isPointed: isPointed,
          )
        ],
      ),
    );
  }
}
