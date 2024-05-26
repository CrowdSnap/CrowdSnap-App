import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'image_picker_state.g.dart';

@riverpod
class ImageState extends _$ImageState {
  int _counter = 0;
  
  // Método que se encarga de proveer el estado actual de la imagen seleccionada.
  // Por defecto, siempre devuelve null indicando que no hay imagen seleccionada inicialmente.
  @override
  File? build() => null;

  // Coger el valor actual del contador.
  int get counter => _counter;

  // Método para actualizar el estado de la imagen.
  // Recibe un archivo de imagen (de tipo File) como parámetro (puede ser null para limpiar la selección).
  void setImage(File? image) {
    state = image;
  }

  // Método para limpiar el estado de la imagen.
  void clearImage() {
    state = null;
  }

  // Método para incrementar el contador de la imagen.
  void incrementCounter() {
    _counter++;
  }

  // Método para reiniciar el contador de la imagen.
  void resetCounter() {
    _counter = 0;
  }
}
