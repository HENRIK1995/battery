import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int? _battery;
  static const platform = MethodChannel('samples.flutter.dev/battery');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getBatteryLevel();
    });
  }

  Future<void> _getBatteryLevel() async {
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      setState(() {
        _battery = result;
      });
    } on PlatformException catch (_) {
      _showAlert();
    }
  }

  Future<void> _showAlert() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Device battery level can not be determined.'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Something went wrong while getting the battery status.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Your battery level is:',
            ),
            if(_battery != null)
            Text(
              '$_battery %',
              style: Theme.of(context).textTheme.headlineMedium,
            )
            else
              Text(
                'Unavailable',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ElevatedButton(
              onPressed: _getBatteryLevel,
              child: const Text('Check Battery Level'),
            ),
          ],
        ),
      ),
    );
  }
}