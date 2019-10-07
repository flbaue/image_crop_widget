# image_crop_widget

A Flutter widget to crop images. The widget is completly written in Dart and has minimal dependencies.

The widget displays the image within the given layout space. Ontop of the image a transparent rectangular overlay, with handles on each corner, is drawn. The overlay handles can be draged by touch to adjust the cropping area.

![Example](/assets/example.png)

By calling the `cropImage()` method on the widget's state object, the image area that is marked by the overlay is returned as a new image object.

To aquire the widget's state you can use a `GlobalKey` object.

Example:

```Dart
import 'dart:ui'; // This imports the 'Image' class.

final key = GlobalKey<ImageCropState>();
Image imageObject = ...

...

ImageCrop(key: key, image: imageObject) // This could be used inside a  build method.

...

final cropedImage = await key.currentState.cropImage(); // This could be used inside a 'onPress' handler method.
```

## How to create a image object

The `Image` class from `dart:ui` is typically not instantiated directly. Instead you could convert your image data into a `Uint8List` and instantiate the image like this:

```Dart
Uint8List bytes = ...
final codec = await instantiateImageCodec(bytes);
final frame = await codec.getNextFrame();
final image = frame.image;
```
