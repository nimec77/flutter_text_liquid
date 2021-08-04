import 'package:flutter/material.dart';

class ImageTest extends StatefulWidget {
  const ImageTest({Key? key}) : super(key: key);

  @override
  _ImageTestState createState() => _ImageTestState();
}

class _ImageTestState extends State<ImageTest> {
  late final ExactAssetImage _assetImage;
  ImageStream? _imageStream;
  ImageInfo? _imageInfo;

  @override
  void initState() {
    _assetImage = const ExactAssetImage('assets/no_data.png');
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_imageStream == null) {
      final listener = ImageStreamListener(_updateImage);
      _imageStream = _assetImage.resolve(createLocalImageConfiguration(context))..addListener(listener);
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
    return Image(image: _assetImage, fit: BoxFit.fill);
  }
}
