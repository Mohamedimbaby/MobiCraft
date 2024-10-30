import 'package:flutter/material.dart';
import 'package:mobicraft/widgets/base_widget/base_widget.dart';
import 'package:mobicraft/widgets/image/attributes/app_image_keys.dart';

class AppImage extends BaseWidget{
  @override
  Widget generate(Map<String, dynamic> attributes) {
    return Image.asset(
      attributes[AssetImageAttributeKeys.assetName] as String? ?? '', // Required: Asset name/path
      width: attributes[AssetImageAttributeKeys.width] as double?,
      height: attributes[AssetImageAttributeKeys.height] as double?,
      fit: attributes[AssetImageAttributeKeys.fit] as BoxFit? ?? BoxFit.cover,
      alignment: attributes[AssetImageAttributeKeys.alignment] as Alignment? ?? Alignment.center,
      color: attributes[AssetImageAttributeKeys.color] as Color?,
      colorBlendMode: attributes[AssetImageAttributeKeys.colorBlendMode] as BlendMode?,
      repeat: attributes[AssetImageAttributeKeys.repeat] as ImageRepeat? ?? ImageRepeat.noRepeat,
      matchTextDirection: attributes[AssetImageAttributeKeys.matchTextDirection] as bool? ?? false,
      gaplessPlayback: attributes[AssetImageAttributeKeys.gaplessPlayback] as bool? ?? false,
    );
  }

}