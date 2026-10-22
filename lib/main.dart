import 'package:flutter/material.dart';
import 'theme/pixel_tokens.dart';
import 'state/widget_editor_state.dart';
import 'ui/creator_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final state = WidgetEditorState();
  state.initialize().then((_) {
    runApp(PixelBtApp(state: state));
  });
}

class PixelBtApp extends StatelessWidget {
  final WidgetEditorState state;

  const PixelBtApp({required this.state, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pixel BT Widget',
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: PixelTokens.surfaceDarkest,
        colorScheme: const ColorScheme.dark(
          primary: PixelTokens.textPrimary,
          surface: PixelTokens.surfaceDark,
        ),
      ),
      themeMode: ThemeMode.dark,
      home: CreatorScreen(state: state),
    );
  }
}
