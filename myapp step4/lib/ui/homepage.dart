import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/counter_controller.dart';

class MyHomePage extends StatelessWidget {
  var title;

  MyHomePage

  ({super.key, required this.title});


  // increment counter, get current time and subtract from previous time then add to list

  var controller = Get.put(CounterController());

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Obx(
          ()=> Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Long press to display count:',
              ),
              Text(
                controller.displayCounter.value.toString(),
                style: Theme
                    .of(context)
                    .textTheme
                    .headlineMedium,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Obx(
        () => FloatingActionButton(
          onPressed: controller.incrementCounterAndAddToList,
          backgroundColor: controller.isRunning.value ? Colors.green : Colors
              .blue,
          tooltip: 'Increment',
          child: GestureDetector(
            onLongPress: () {
              controller.displayCounterListitem();
            },
            child: const Icon(
              Icons.add,
            ),
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

