import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widget_that_fits/widget_that_fits.dart';

void main() {
  testWidgets('Shows only first child that fits in available space', (widgetTester) async {
    Widget build(double width) {
      return Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: SizedBox(
            width: width,
            child: WidgetThatFits(
              children: [
                Container(key: const ValueKey(0), width: 300, height: 100, color: const Color(0xFF0000FF)),
                Container(key: const ValueKey(1), width: 200, height: 100, color: const Color(0xFF00FF00)),
                Container(key: const ValueKey(2), width: 100, height: 100, color: const Color(0xFFFF0000)),
              ],
            ),
          ),
        ),
      );
    }

    await widgetTester.pumpWidget(build(500));
    expect(find.byType(Container), findsOneWidget);
    expect(find.byKey(const ValueKey(0)), findsOneWidget);
    expect(find.byKey(const ValueKey(1)), findsNothing);
    expect(find.byKey(const ValueKey(2)), findsNothing);

    await widgetTester.pumpWidget(build(250));
    expect(find.byType(Container), findsOneWidget);
    expect(find.byKey(const ValueKey(0)), findsNothing);
    expect(find.byKey(const ValueKey(1)), findsOneWidget);
    expect(find.byKey(const ValueKey(2)), findsNothing);

    await widgetTester.pumpWidget(build(150));
    expect(find.byType(Container), findsOneWidget);
    expect(find.byKey(const ValueKey(0)), findsNothing);
    expect(find.byKey(const ValueKey(1)), findsNothing);
    expect(find.byKey(const ValueKey(2)), findsOneWidget);

    await widgetTester.pumpWidget(build(50));
    expect(find.byType(Container), findsOneWidget);
    expect(find.byKey(const ValueKey(0)), findsNothing);
    expect(find.byKey(const ValueKey(1)), findsNothing);
    expect(find.byKey(const ValueKey(2)), findsOneWidget);
  });
}
