import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:widget_that_fits/widget_that_fits.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 8,
          children: <Widget>[
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 200),
              child: UploadProgressWidget(uploadProgress: 0.75),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 100),
              child: UploadProgressWidget(uploadProgress: 0.75),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 50),
              child: UploadProgressWidget(uploadProgress: 0.75),
            ),
          ],
        ),
      ),
    );
  }
}

class UploadProgressWidget extends StatelessWidget {
  const UploadProgressWidget({super.key, required this.uploadProgress});

  static final _percentFormatter = NumberFormat.percentPattern();

  final double uploadProgress;

  @override
  Widget build(BuildContext context) {
    return WidgetThatFits(
      axes: const {Axis.horizontal},
      children: [
        Row(
          spacing: 8,
          children: [
            Text(_percentFormatter.format(uploadProgress)),
            SizedBox(
              width: 100,
              child: LinearProgressIndicator(value: uploadProgress),
            ),
          ],
        ),
        SizedBox(
          width: 100,
          child: LinearProgressIndicator(value: uploadProgress),
        ),
        Text(_percentFormatter.format(uploadProgress)),
      ],
    );
  }
}
