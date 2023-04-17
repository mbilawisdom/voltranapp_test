import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VoltranApp Test 3',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Voltran App Test 3'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  int _displayCounter = 0;

  bool isRunning = false;

  var currentTime;

  var countList = <CountModel>[];
  var additionalCountList = <CountModel>[];
  var _previousCountDate = DateTime.now();

  // increment counter, get current time and subtract from previous time then add to list
  void _incrementCounterAndAddToList() {
    var dateTimeNow = DateTime.now();

    setState(() {
      // increment counter
      _counter++;

      // subtract current time from previousCount time
      currentTime = dateTimeNow.difference(_previousCountDate).inMilliseconds;

      // check if count is == 1 which is the first count when click then set time to 0 milliseconds
      if (_counter == 1) {
        countList.add(CountModel(count: _counter, time: 0));

        _previousCountDate = dateTimeNow;
        return;
      }

      if (isRunning == true) {
        additionalCountList.add(CountModel(count: _counter, time: currentTime));

        _previousCountDate = dateTimeNow;
        return;
      }

      countList.add(CountModel(count: _counter, time: currentTime));

      _previousCountDate = dateTimeNow;
    });
  }

  Future<void> _displayCounterListitem() async {
    await listCounts();
    if (isRunning == false && additionalCountList.isNotEmpty) {
      setState(() {
        countList.addAll(additionalCountList);
        additionalCountList.clear();
      });

      await _displayCounterListitem();

      return;
    }

   await Future.delayed(Duration(seconds: 1));
    setState(() {
      _displayCounter = _counter = 0;
    });
  }

  Future<void> listCounts() async {
    for (var element in countList) {
      setState(() {
        isRunning = true;
      });
      await Future.delayed(Duration(milliseconds: element.time!))
          .whenComplete(() {
        setState(() {
          _displayCounter = element.count!;
        });
      });
    }

    setState(() {
      isRunning = false;
      countList.clear();
    });
  }

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
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Long press to display count:',
            ),
            Text(
              '$_displayCounter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounterAndAddToList,
        backgroundColor: isRunning ? Colors.green : Colors.blue,
        tooltip: 'Increment',
        child: GestureDetector(
          onLongPress: () {
            _displayCounterListitem();
          },
          child: Icon(Icons.add,),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class CountModel {
  int? count;
  int? time;

  CountModel({this.count, this.time});
}
