import 'dart:io';

import 'package:flutter/material.dart';
//Hannes Hauenstein


class ImageUtils {

  static final loadingAnnimation = ImageUtils.from('assets/loading.gif');

  static ImageProvider from(String path, {String alt, double width, double height}) {
    if (path == null) {
      path = alt;
    }

    ImageProvider provider;
    if (path.startsWith("assets/")) {
      provider = AssetImage(path);
    } else if (path.startsWith("http")) {
      provider = NetworkImage(path);
    } else {
      provider = FileImage(File(path));
    }

    return ResizeImage.resizeIfNeeded(width != null ? width.toInt() : width, height != null ? height.toInt() : height, provider);
  }

  static String getMimeType(String path) {
    var types = ['png', 'jpg', 'jpeg', 'tiff', 'gpg', 'webp'];
    for (String type in types) {
      if (path.endsWith(type)) {
        return 'image/' + type;
      }
    }
    return 'image/unknown';
  }

  static bool isImageType(String path) {
    return getMimeType(path) != 'image/unknown';
  }
}