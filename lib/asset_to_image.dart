import 'package:flutter/material.dart';

class AssetToImage extends StatefulWidget {
  const AssetToImage({Key? key}) : super(key: key);

  @override
  _AssetToImageState createState() => _AssetToImageState();
}

class _AssetToImageState extends State<AssetToImage> {
  late final Image _assetImage;
  ImageStream? _imageStream;
  ImageInfo? _imageInfo;

  @override
  void initState() {
    super.initState();
    _assetImage = Image.asset(
      'assets/no_data.png',
      fit: BoxFit.cover,
    );
  }

  @override
  void didChangeDependencies() {
    if (_imageStream == null) {
      final listener = ImageStreamListener(_updateImage);
      _imageStream = _assetImage.image.resolve(createLocalImageConfiguration(context))..addListener(listener);
    }
    super.didChangeDependencies();
  }

  void _updateImage(ImageInfo imageInfo, bool synchronousCall) {
    setState(() {
      _imageInfo?.dispose();
      _imageInfo = imageInfo;
      debugPrint('${imageInfo.image.width}x${imageInfo.image.height}');
    });
  }

  @override
  void dispose() {
    _imageStream?.removeListener(ImageStreamListener(_updateImage));
    _imageInfo?.dispose();
    _imageInfo = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _assetImage;
  }
}
