import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixel_bt_widget/main.dart';
import 'package:pixel_bt_widget/state/widget_editor_state.dart';

void main() {
  testWidgets('PixelBtApp renders with WidgetEditorState', (WidgetTester tester) async {
    final state = WidgetEditorState();
    await tester.pumpWidget(PixelBtApp(state: state));
    expect(find.text('Pixel BT Studio'), findsOneWidget);
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
