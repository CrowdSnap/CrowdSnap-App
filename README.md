# crowd_snap

A new Flutter project.

## Getting Started

1. Instalaciones: 
    1. Extensiones VSCode
        1. Flutter
        2. Dart
        3. Awesome Flutter Snippets
        4. Flutter Riverpod Snippets
        5. Pubspec Assist
    
    2. Sistema:
        1. Flutter SDK
  

2. Ejecutar una vez el proyecto en android para que se creen los archivos necesarios


3. Si usáis la extension de vscode de Language Support for Java by Red Hat deshabilitar la extension      


4. Ejecutar en la terminal del proyecto el comando: 
    ```
    dart run build_runner watch
    ```
    Este comando lo usaremos para poder trabajar con el código autogenerado de riverpod con las anotaciones.
    Una vez ejecutado el comando no se puede usar la terminal ni cerrarla. Se tendrá que abrir otra para poder usarla.


5. Añadir al .env las variables de entorno
    ```
    R2_ACCESS_KEY=
    R2_SECRET_ACCESS_KEY=
    R2_URL=
    R2_PUBLIC_URL=
    MONGO_URL=
    PUSH_NOTIFICATION_URL=
    ```


6. Añadir esta linea al local.properties de android
    ```
    flutter.minSdkVersion=21
    ```