import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kasih/core/widgets/picker.dart';

void main() {
  Widget buildTestApp(Widget child) {
    return MaterialApp(
      locale: const Locale('id', 'ID'),
      supportedLocales: const [Locale('id', 'ID'), Locale('en')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Scaffold(body: child),
    );
  }

  testWidgets('Picker.pickDate allows selecting dates from historical range', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildTestApp(
        Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () async {
                await Picker.pickDate(
                  context,
                  currentTime: DateTime(1990, 5, 20),
                  minTime: DateTime(1900),
                  maxTime: DateTime(2026, 12, 31),
                  initialDatePickerMode: DatePickerMode.year,
                );
              },
              child: const Text('Pick Date'),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Pick Date'));
    await tester.pumpAndSettle();

    // Verify date picker is opened and 1990 is visible
    expect(find.byType(DatePickerDialog), findsOneWidget);
    expect(find.text('1990'), findsWidgets);
  });

  testWidgets('Picker.pickDate default minTime allows dates before year - 5', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildTestApp(
        Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () async {
                await Picker.pickDate(
                  context,
                  currentTime: DateTime(1985, 1, 1),
                );
              },
              child: const Text('Pick Default'),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Pick Default'));
    await tester.pumpAndSettle();

    // Without clamping / historical minTime, showDatePicker would assert-fail.
    expect(find.byType(DatePickerDialog), findsOneWidget);
  });
}
