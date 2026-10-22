import 'package:flutter/material.dart';
import '../models/bt_device_item.dart';
import '../models/device_icon_type.dart';
import '../state/widget_editor_state.dart';
import '../theme/pixel_tokens.dart';
import 'widgets/widget_preview_card.dart';
import 'widgets/config_controls_sheet.dart';
import 'widgets/device_edit_dialog.dart';

class CreatorScreen extends StatefulWidget {
  final WidgetEditorState state;
  const CreatorScreen({super.key, required this.state});
  @override
  State<CreatorScreen> createState() => _CreatorScreenState();
}

class _CreatorScreenState extends State<CreatorScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.state,
    builder: (_, _) => Scaffold(
      backgroundColor: PixelTokens.surfaceDarkest,
      appBar: AppBar(
        backgroundColor: PixelTokens.surfaceDark, elevation: 0,
        title: const Text('Pixel BT Studio', style: TextStyle(color: PixelTokens.textPrimary, fontWeight: FontWeight.bold)),
        actions: [_badge()],
      ),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        const Text('Live Home Widget Preview', style: TextStyle(color: PixelTokens.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        WidgetPreviewCard(config: widget.state.config, devices: widget.state.devices, onToggleConnection: (mac) => widget.state.toggleDeviceConnection(mac), onEditDevice: (d) => _show(d)),
        const SizedBox(height: 24),
        SegmentedButton<int>(selected: {_selectedTab}, onSelectionChanged: (s) => setState(() => _selectedTab = s.first), segments: const [ButtonSegment(value: 0, label: Text('Customize Style')), ButtonSegment(value: 1, label: Text('Manage Devices'))]),
        const SizedBox(height: 16),
        _selectedTab == 0 ? ConfigControlsSheet(config: widget.state.config, onConfigChanged: (cfg) => widget.state.updateConfig(cfg)) : _buildDevicesList(),
      ]),
    ),
  );

  Widget _badge() => Center(child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(border: Border.all(color: PixelTokens.surfaceBorder), borderRadius: BorderRadius.circular(6)), child: const Text('ISO 9241-11', style: TextStyle(color: PixelTokens.textPrimary, fontSize: 11))));

  Widget _buildDevicesList() => widget.state.devices.isEmpty ? Center(child: Text('No devices found', style: TextStyle(color: PixelTokens.textPrimary.withAlpha(128)))) : ListView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: widget.state.devices.length, itemBuilder: (_, i) => _tile(widget.state.devices[i]));

  Widget _tile(BtDeviceItem d) => Padding(padding: const EdgeInsets.only(bottom: 12), child: Material(color: PixelTokens.surfaceDark, borderRadius: BorderRadius.circular(PixelTokens.radiusSubtle), child: ListTile(leading: Icon(d.iconType.icon, color: PixelTokens.textPrimary), title: Text(d.displayName, style: const TextStyle(color: PixelTokens.textPrimary, fontWeight: FontWeight.w500)), subtitle: Text(d.isConnected ? 'Connected' : 'Disconnected', style: TextStyle(color: d.isConnected ? PixelTokens.textPrimary : PixelTokens.textPrimary.withAlpha(128))), trailing: SizedBox(width: 120, child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [IconButton(icon: Icon(d.isFavorite ? Icons.star : Icons.star_outline, color: PixelTokens.textPrimary), onPressed: () => widget.state.toggleFavorite(d.id)), IconButton(icon: const Icon(Icons.edit, color: PixelTokens.textPrimary), onPressed: () => _show(d)), if (!d.isConnecting) IconButton(icon: Icon(d.isConnected ? Icons.link_off : Icons.link, color: PixelTokens.textPrimary), onPressed: () => widget.state.toggleDeviceConnection(d.macAddress))])))));

  void _show(BtDeviceItem d) => showDeviceEditDialog(context, d, (name, icon, fav) async {
    await widget.state.updateDeviceCustomName(d.id, name);
    await widget.state.updateDeviceIcon(d.id, icon);
    if (fav != d.isFavorite) await widget.state.toggleFavorite(d.id);
  });
}
