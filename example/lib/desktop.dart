import 'dart:math' as math;

import 'package:flutter/material.dart';
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
      debugShowCheckedModeBanner: false,
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
  final _names = [_kNames.first];
  var _maxVisibleNames = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Center(
          child: Row(
            children: [
              SizedBox(
                width: 380,
                child: Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: Text("Number of followers (${_names.length})"),
                        trailing: SegmentedButton<bool>(
                          emptySelectionAllowed: true,
                          segments: [
                            ButtonSegment(
                              value: false,
                              icon: Icon(Icons.remove),
                            ),
                            ButtonSegment(value: true, icon: Icon(Icons.add)),
                          ],
                          selected: const {},
                          onSelectionChanged: (value) => setState(() {
                            if (value.contains(true)) {
                              _names.add(
                                _kNames[_names.length % _kNames.length],
                              );
                            } else {
                              if (_names.length > 1) {
                                _names.removeLast();
                              }
                            }
                          }),
                        ),
                      ),
                      ListTile(
                        title: Text(
                          "Max visible followers ($_maxVisibleNames)",
                        ),
                        trailing: SegmentedButton<bool>(
                          emptySelectionAllowed: true,
                          segments: [
                            ButtonSegment(
                              value: false,
                              icon: Icon(Icons.remove),
                            ),
                            ButtonSegment(value: true, icon: Icon(Icons.add)),
                          ],
                          selected: const {},
                          onSelectionChanged: (value) => setState(() {
                            if (value.contains(true)) {
                              _maxVisibleNames++;
                            } else {
                              if (_maxVisibleNames > 0) {
                                _maxVisibleNames--;
                              }
                            }
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              VerticalDivider(),
              Expanded(
                child: Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          foregroundImage: NetworkImage(
                            "https://i.pravatar.cc/150?img=3",
                          ),
                        ),
                        title: Text("Ethan Johnson"),
                        subtitle: FollowedByLabel(
                          followers: _names,
                          maxVisibleFollowers: _maxVisibleNames,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            child: const Text('VIEW PROFILE'),
                            onPressed: () {},
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FollowedByLabel extends StatelessWidget {
  const FollowedByLabel({
    super.key,
    required this.followers,
    this.maxVisibleFollowers = 2,
    int? totalFollowers,
  }) : totalFollowers = totalFollowers ?? followers.length;

  final List<String> followers;
  final int maxVisibleFollowers;
  final int totalFollowers;

  @override
  Widget build(BuildContext context) {
    if (totalFollowers == 0) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);

    Widget buildText(String followers, int otherCount) {
      return Text.rich(
        TextSpan(
          children: [
            TextSpan(text: "Followed by "),
            if (followers.isNotEmpty) ...[
              TextSpan(
                text: followers,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              if (otherCount > 0) ...[
                TextSpan(text: " and "),
                TextSpan(
                  // Poor man's pluralization
                  text: otherCount == 1
                      ? "$otherCount other"
                      : "$otherCount others",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ] else
              TextSpan(
                // Poor man's pluralization
                text: otherCount == 1
                    ? "$otherCount person"
                    : "$otherCount people",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
          ],
        ),
        style: theme.textTheme.bodySmall,
      );
    }

    final maxVisibleFollowers = math.min(
      this.maxVisibleFollowers,
      followers.length,
    );

    return WidgetThatFits(
      children: List.generate(maxVisibleFollowers + 1, (index) {
        final visibleFollowersCount = maxVisibleFollowers - index;
        final followersToShow = followers
            .take(visibleFollowersCount)
            .join(', ');
        final otherCount = totalFollowers - visibleFollowersCount;
        return buildText(followersToShow, otherCount);
      }),
    );
  }
}

const _kNames = [
  "Joy Williamson",
  "Yvonne Lane",
  "Velma Good",
  "Garfield Graves",
  "Devon Galvan",
  "Bryce Sullivan",
  "Janelle Escobar",
  "Terri Norman",
  "Noah Rubio",
  "Eduardo Madden",
  "Sylvia Robbins",
  "Juliana Proctor",
  "Alice Hahn",
  "Leonard Mcgrath",
  "Jodi Mcknight",
  "Irwin Oconnell",
  "Roberta Herrera",
  "Tammie Odonnell",
  "Alejandro Donaldson",
  "Dick Bush",
  "Gordon Blair",
  "Mervin Riggs",
  "Karin Patton",
  "Fritz Trujillo",
  "Kristine Decker",
  "Lauren Montes",
  "Marisa Strickland",
  "Scotty Ibarra",
  "Ivory Guerrero",
  "Alison Rich",
];
