// lib/core/errors/result.dart
import 'package:fpdart/fpdart.dart';
import 'package:crowd_snap/core/errors/exceptions.dart'; // Verify this import path

typedef Result<S, E extends AppException> = Either<E, S>;
