import 'dart:io';
import 'dart:typed_data';
import 'package:crowd_snap/features/auth/presentation/notifier/google_sign_up_notifier.dart';
import 'package:crowd_snap/features/auth/presentation/widgets/age/birth_date_input_google_sign_up.dart';
import 'package:crowd_snap/features/auth/presentation/widgets/google_register_button_submit.dart';
import 'package:crowd_snap/features/auth/presentation/widgets/google_user_name_input.dart';
import 'package:crowd_snap/features/imgs/presentation/notifier/image_picker_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

// Widget con estado que representa la vista para el registro con Google.
class GoogleSignUpView extends ConsumerStatefulWidget {
  // Constructor para el widget `GoogleSignUpView`.
  //
  // - `key`: Clave opcional para la identificación del widget.
  const GoogleSignUpView({super.key});

  // Método que crea el estado interno del widget.
  //
  // Este método es responsable de crear el estado interno del widget que administrará los datos relacionados con la interfaz de usuario e interactuará con los providers de Riverpod para la lógica.
  @override
  _GoogleSignUpScreenState createState() => _GoogleSignUpScreenState();
}

// Representa el estado interno del widget `GoogleSignUpView`.
class _GoogleSignUpScreenState extends ConsumerState<GoogleSignUpView>
    with SingleTickerProviderStateMixin {
  // Future utilizada para la inicialización del usuario de Google.
  late Future<void> _initializeUserFuture;

  // AnimationController para manejar animaciones.
  late AnimationController _animationController;

  // Animación para escalar la imagen de perfil.
  late Animation<double> _scaleAnimation;

  // Animación para desplazar la imagen de perfil.
  late Animation<Offset> _offsetAnimation;

  // Bandera que indica si la imagen de perfil está expandida.
  bool _isImageExpanded = false;

  // Método llamado en el ciclo de vida del widget cuando se inicializa.
  @override
  void initState() {
    super.initState();

    // Inicializa el Future para la inicialización del usuario de Google utilizando el provider `googleSignUpNotifierProvider.notifier`.
    _initializeUserFuture =
        ref.read(googleSignUpNotifierProvider.notifier).initialize();

    // Crea un AnimationController para manejar animaciones.
    _animationController = AnimationController(
      vsync: this, // Sincroniza la animación con el ciclo de vida del widget
      duration:
          const Duration(seconds: 3), // Duración de la animación (3 segundos)
    )..repeat(reverse: true); // Repetir la animación en sentido inverso

    // Define la animación para escalar la imagen de perfil.
    _scaleAnimation =
        Tween<double>(begin: 1.0, end: 1.2).animate(_animationController);

    // Define la animación para desplazar la imagen de perfil.
    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.0, -0.5), // Desplazamiento vertical hacia abajo
    ).animate(_animationController);
  }

  // Método llamado en el ciclo de vida del widget cuando se elimina.
  @override
  void dispose() {
    // Libera los recursos utilizados por el AnimationController.
    _animationController.dispose(); // Disponer el AnimationController
    super.dispose();
  }

  // Maneja la selección de la cámara para obtener una imagen de perfil.
  Future<void> _getCamera(WidgetRef ref) async {
    final picker = ImagePicker(); // Crea un picker de imágenes
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      Uint8List imageData = await pickedFile.readAsBytes();
      final editedImage = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageCropper(
            image: imageData, // <-- Uint8List of image
            reversible: true,
          ),
        ),
      );
      if (editedImage != null) {
        Directory tempDir = await getTemporaryDirectory();
        String tempPath = tempDir.path;
        ref.read(imageStateProvider.notifier).incrementCounter();
        final counter = ref.read(imageStateProvider.notifier).counter;
        File file = File('$tempPath/$counter-avatar.jpeg');
        final croppedImage = await file.writeAsBytes(editedImage);
        ref
            .read(googleSignUpNotifierProvider.notifier)
            .updateUserImage(croppedImage.path);
      }
    }
  }

  // Maneja la selección de la galería para obtener una imagen de perfil.
  Future<void> _getGallery(WidgetRef ref) async {
    final picker = ImagePicker(); // Crea un picker de imágenes
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      Uint8List imageData = await pickedFile.readAsBytes();
      final editedImage = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageCropper(
            image: imageData, // <-- Uint8List of image
            reversible: true,
          ),
        ),
      );
      if (editedImage != null) {
        Directory tempDir = await getTemporaryDirectory();
        String tempPath = tempDir.path;
        ref.read(imageStateProvider.notifier).incrementCounter();
        final counter = ref.read(imageStateProvider.notifier).counter;
        File file = File('$tempPath/$counter-avatar.jpeg');
        final croppedImage = await file.writeAsBytes(editedImage);
        ref
            .read(googleSignUpNotifierProvider.notifier)
            .updateUserImage(croppedImage.path);
      }
    }
  }

  // Controla la expansión y contracción de la imagen de perfil.
  void _toggleImageExpansion() {
    setState(() {
      _isImageExpanded = !_isImageExpanded;
      if (_isImageExpanded) {
        // Detiene la animación al expandir la imagen.
        _animationController.stop();
      } else {
        // Reanuda la animación al contraer la imagen.
        _animationController.repeat(reverse: true);
      }
    });
  }

  // Método llamado para construir el widget.
  @override
  Widget build(BuildContext context) {
    // Obtiene el estado del formulario del provider `googleSignUpNotifierProvider`.
    final formState = ref.watch(googleSignUpNotifierProvider);
    // Obtiene el notifier del formulario del provider `googleSignUpNotifierProvider`.
    final formValues = ref.watch(googleSignUpNotifierProvider.notifier);

    // Scaffold que representa la estructura principal de la pantalla.
    return Scaffold(
      appBar: AppBar(
        // Título del AppBar que saluda al usuario por su nombre.
        title: Text('Hola ${formState.name.split(' ')[0]}'),
      ),
      resizeToAvoidBottomInset: false, // Evita que el contenido se redimensione
      body: FutureBuilder(
        future: _initializeUserFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Muestra un indicador de progreso circular mientras se inicializa el usuario.
            return const Center(child: CircularProgressIndicator());
          }
          return Consumer(
            builder: (context, ref, _) {
              return SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    child: Column(
                      children: [
                        // Texto que indica al usuario que complete su perfil.
                        const Text(
                            'Para continuar, por favor completa tu perfil'),
                        const SizedBox(height: 20),

                        // Imagen de perfil con funcionalidad para expandir y cambiar la imagen
                        GestureDetector(
                          onTap: _toggleImageExpansion,
                          child: AnimatedBuilder(
                            animation: _animationController,
                            builder: (context, child) {
                              // Animación de escala para la imagen de perfil.
                              return Transform.scale(
                                scale: _isImageExpanded
                                    ? 1.0
                                    : _scaleAnimation.value,
                                child: Transform.translate(
                                  offset: _isImageExpanded
                                      ? Offset.zero
                                      : _offsetAnimation.value,
                                  child: CircleAvatar(
                                    radius: _isImageExpanded ? 100 : 50,
                                    backgroundImage: formState
                                            .userImage.isNotEmpty
                                        ? FileImage(File(formState.userImage))
                                            as ImageProvider<Object>?
                                        : formState.googleImage.isNotEmpty
                                            ? NetworkImage(
                                                    formState.googleImage)
                                                as ImageProvider<Object>?
                                            : null,
                                    child: formState.userImage.isEmpty &&
                                            formState.googleImage.isEmpty
                                        ? const Icon(Icons.person, size: 50)
                                        : null,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        // Botones para seleccionar una imagen de la cámara o galería (solo visibles cuando la imagen está expandida).
                        if (_isImageExpanded) const SizedBox(height: 20),

                        // Texto que indica como cambiar la imagen (solo visible cuando la imagen no está expandida).
                        if (_isImageExpanded)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {
                                  _getCamera(ref);
                                },
                                icon: const Icon(Icons.camera_alt),
                                label: const Text('Camera'),
                              ),
                              const SizedBox(width: 20),
                              ElevatedButton.icon(
                                onPressed: () {
                                  _getGallery(ref);
                                },
                                icon: const Icon(Icons.photo_library),
                                label: const Text('Gallery'),
                              ),
                            ],
                          ),

                        // Texto que indica como cambiar la imagen (solo visible cuando la imagen no está expandida).
                        if (!_isImageExpanded) const SizedBox(height: 20),
                        if (!_isImageExpanded)
                          const Text(
                              'Pulsando encima de la imagen puedes cambiarla'),
                        const SizedBox(height: 16),
                        // Campos de texto para nombre y usuario.
                        TextFormField(
                          initialValue: formState.name,
                          decoration: const InputDecoration(labelText: 'Name'),
                          onChanged: (value) => formValues.updateNombre(value),
                        ),
                        const GoogleUserNameInput(),
                        // Widget personalizado para la entrada de fecha de nacimiento (se asume que existe un widget `BirthDateInputGoogleSignUp`).
                        const BirthDateInputGoogleSignUp(),
                        const SizedBox(height: 16),
                        // Widget personalizado para el botón de registro
                        const GoogleRegisterButtonSubmit(),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
