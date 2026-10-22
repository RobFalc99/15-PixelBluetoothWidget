import 'package:flutter/material.dart';
import '../../models/bt_device_item.dart';
import '../../models/device_icon_type.dart';
import '../../theme/pixel_tokens.dart';

void showDeviceEditDialog(BuildContext context, BtDeviceItem device,
    Function(String, DeviceIconType, bool) onSave) {
  final name = TextEditingController(text: device.displayName);
  var icon = device.iconType;
  var fav = device.isFavorite;
  final border = OutlineInputBorder(borderRadius: BorderRadius.circular(PixelTokens.radiusSubtle), borderSide: const BorderSide(color: PixelTokens.surfaceBorder));
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: PixelTokens.surfaceDark,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(PixelTokens.radiusStandard))),
    builder: (c) => StatefulBuilder(
      builder: (c, setState) => SingleChildScrollView(
        padding: EdgeInsets.only(bottom: MediaQuery.of(c).viewInsets.bottom + 16, left: 16, right: 16, top: 16),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Edit Device', style: Theme.of(c).textTheme.headlineSmall?.copyWith(color: PixelTokens.textPrimary, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          TextField(controller: name, style: const TextStyle(color: PixelTokens.textPrimary), decoration: InputDecoration(labelText: 'Device Name', labelStyle: TextStyle(color: PixelTokens.textPrimary.withAlpha(179)), filled: true, fillColor: PixelTokens.surfaceMedium, border: border, enabledBorder: border)),
          const SizedBox(height: 16),
          Text('Device Icon', style: Theme.of(c).textTheme.titleMedium?.copyWith(color: PixelTokens.textPrimary)),
          const SizedBox(height: 8),
          Wrap(spacing: 8, runSpacing: 8, children: DeviceIconType.values.map((t) {
            final sel = icon == t;
            return Container(decoration: BoxDecoration(border: Border.all(color: sel ? PixelTokens.textPrimary : PixelTokens.surfaceBorder, width: sel ? 2 : 1), borderRadius: BorderRadius.circular(8)), child: IconButton(onPressed: () => setState(() => icon = t), icon: Icon(t.icon, color: sel ? PixelTokens.surfaceDarkest : PixelTokens.textPrimary.withAlpha(128)), tooltip: t.label, style: IconButton.styleFrom(backgroundColor: sel ? PixelTokens.textPrimary : null)));
          }).toList()),
          const SizedBox(height: 16),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Favorite', style: Theme.of(c).textTheme.titleMedium?.copyWith(color: PixelTokens.textPrimary)),
            Switch(value: fav, onChanged: (v) => setState(() => fav = v), activeTrackColor: PixelTokens.surfaceLight, activeThumbColor: PixelTokens.textPrimary),
          ]),
          const SizedBox(height: 16),
          SizedBox(width: double.infinity, height: PixelTokens.touchTargetMinimum, child: FilledButton(onPressed: () { onSave(name.text, icon, fav); Navigator.pop(c); }, style: FilledButton.styleFrom(backgroundColor: PixelTokens.textPrimary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(PixelTokens.radiusSubtle))), child: Text('Save', style: Theme.of(c).textTheme.titleMedium?.copyWith(color: PixelTokens.surfaceDarkest, fontWeight: FontWeight.bold)))),
        ]),
      ),
    ),
  );
}
