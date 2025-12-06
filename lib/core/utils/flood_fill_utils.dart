
import 'dart:async';
import 'dart:collection';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

class FloodFillUtils {
  
  /// Converts a ui.Image to an img.Image (from the image package) for pixel manipulation.
  static Future<img.Image> convertUiImageToImgImage(ui.Image uiImage) async {
    final ByteData? byteData = await uiImage.toByteData(format: ui.ImageByteFormat.rawRgba);
    if (byteData == null) throw Exception("Failed to get byte data");
    
    return img.Image.fromBytes(
      width: uiImage.width,
      height: uiImage.height,
      bytes: byteData.buffer,
      format: img.Format.uint8,
      order: img.ChannelOrder.rgba,
    );
  }

  /// Converts an img.Image back to a ui.Image for display.
  static Future<ui.Image> convertImgImageToUiImage(img.Image image) async {
    final Uint8List bytes = image.getBytes();
    final ui.ImmutableBuffer buffer = await ui.ImmutableBuffer.fromUint8List(bytes);
    
    final ui.ImageDescriptor descriptor = ui.ImageDescriptor.raw(
      buffer,
      width: image.width,
      height: image.height,
      pixelFormat: ui.PixelFormat.rgba8888,
    );
    
    final ui.Codec codec = await descriptor.instantiateCodec();
    final ui.FrameInfo frameInfo = await codec.getNextFrame();
    return frameInfo.image;
  }

  /// Performs a non-recursive flood fill algorithm.
  static img.Image floodFill(img.Image image, int x, int y, Color newColor) {
    if (x < 0 || x >= image.width || y < 0 || y >= image.height) return image;

    final img.Pixel targetPixel = image.getPixel(x, y);
    
    // Create the replacement color
    final img.Color replaceColor = img.ColorRgba8(newColor.red, newColor.green, newColor.blue, newColor.alpha);

    // If the target color is already the replacement color, do nothing
    if (targetPixel.r == replaceColor.r && 
        targetPixel.g == replaceColor.g && 
        targetPixel.b == replaceColor.b && 
        targetPixel.a == replaceColor.a) {
      return image;
    }

    final num targetR = targetPixel.r;
    final num targetG = targetPixel.g;
    final num targetB = targetPixel.b;
    final num targetA = targetPixel.a;

    final Queue<Point> queue = Queue<Point>();
    queue.add(Point(x, y));

    while (queue.isNotEmpty) {
      Point p = queue.removeFirst();
      if (p.x < 0 || p.x >= image.width || p.y < 0 || p.y >= image.height) continue;

      final img.Pixel currentPixel = image.getPixel(p.x, p.y);

      if (currentPixel.r == targetR && 
          currentPixel.g == targetG && 
          currentPixel.b == targetB && 
          currentPixel.a == targetA) {
        
        image.setPixel(p.x, p.y, replaceColor);

        queue.add(Point(p.x + 1, p.y));
        queue.add(Point(p.x - 1, p.y));
        queue.add(Point(p.x, p.y + 1));
        queue.add(Point(p.x, p.y - 1));
      }
    }
    return image;
  }
}

class Point {
  final int x;
  final int y;
  Point(this.x, this.y);
}
