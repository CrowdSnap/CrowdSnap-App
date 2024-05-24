import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:octo_image/octo_image.dart';

OctoSet blurHashSet(String hash, {BoxFit? fit}) {
  return OctoSet(
    placeholderBuilder: (context) => SizedBox.expand(
      child: Image(
        image: BlurHashImage(hash),
        fit: fit ?? BoxFit.cover,
      ),
    ),
    errorBuilder: OctoError.placeholderWithErrorIcon(
      (context) => SizedBox.expand(
        child: Image(
          image: BlurHashImage(hash),
          fit: fit ?? BoxFit.cover,
        ),
      ),
    ),
  );
}