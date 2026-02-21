import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _textEditiongController = TextEditingController();
  int _counter = 0;
  double _offset = 0;
  Color _defaultBackgroundColor = Colors.white;
  final _customBackgroundColor = Colors.grey;


  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  Future<void> _changeBackgroundColor() async {
    setState(() {
      _defaultBackgroundColor = _customBackgroundColor;
    });

    await Future<void>.delayed(const Duration(milliseconds: 500));

    setState(() {
      _defaultBackgroundColor = Colors.white;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        color: _defaultBackgroundColor,
        child: Center(
          child: Column(
            mainAxisAlignment: .center,
            children: [
              const Text('You have pushed the button this many times:'),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              AnimatedPadding(
                duration: const Duration(seconds: 1),
                padding: EdgeInsets.only(top: _offset),
                child: SizedBox(
                  height: 100,
                  width: 300,
                  child: TextField(
                    controller: _textEditiongController,
                    onChanged: (text) async {
                      if (text == 'Down') {
                        if (_counter > 0) {
                          setState(() {
                            _counter = 0;
                          });
                        } else if (_offset < 150){
                          setState(() {
                            _offset = _offset + 50;
                          });
                        } else {
                          await _changeBackgroundColor();
                        }
                      } else if (text == 'Up') {
                        if (_counter < 1000) {
                          setState(() {
                            _counter = _counter + 100;
                          });
                        } else if (_offset > 0) {
                          setState(() {
                            _offset = _offset - 50;
                          });
                        } else {
                          await _changeBackgroundColor();
                        }
                      } else if (text == 'Reset') {
                        setState(() {
                          _counter = 0;
                          _offset = 0;
                          _textEditiongController.clear();
                        });
                      }
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter Command',
                    ),
                  )
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
