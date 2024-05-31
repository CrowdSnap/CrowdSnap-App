import 'package:crowd_snap/core/constants.dart';
import 'package:crowd_snap/core/data/repository_impl/shared_preferences/user_repository_impl.dart';
import 'package:crowd_snap/core/domain/use_cases/shared_preferences/get_user_local_use_case.dart';
import 'package:crowd_snap/features/imgs/data/data_source/comment_data_source.dart';
import 'package:crowd_snap/features/imgs/data/data_source/post_data_source.dart';
import 'package:crowd_snap/features/imgs/data/data_source/image_bucket_data_source.dart';
import 'package:crowd_snap/features/imgs/domain/use_case/avatar_get_use_case.dart';
import 'package:crowd_snap/features/profile/data/data_source/user_posts_data_source.dart';
import 'package:crowd_snap/features/profile/data/repositories_impl/users_repository_impl.dart';
import 'package:crowd_snap/features/profile/presentation/notifier/profile_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crowd_snap/app/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:crowd_snap/app/router/redirect/auth_redirect_provider.dart';
import 'firebase_options.dart';
import 'package:logging/logging.dart';

void main() async {
  final logger = Logger('main');
  await dotenv.load(fileName: '.env');
  final ImageBucketDataSourceImpl imageBucketDataSource =
      ImageBucketDataSourceImpl();
  await imageBucketDataSource.loadEnvVariables();
  final PostDataSourceImpl postDataSource = PostDataSourceImpl();
  await postDataSource.loadEnvVariables();
  final CommentDataSourceImpl commentDataSource = CommentDataSourceImpl();
  await commentDataSource.loadEnvVariables();
  final UserPostsDataSourceImpl userPostsDataSource = UserPostsDataSourceImpl();
  await userPostsDataSource.loadEnvVariables();
  // Inicializa Firebase antes de ejecutar la aplicación.
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseMessaging messaging = FirebaseMessaging.instance;
  final fcmToken = await messaging.getToken();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    // El widget ProviderScope permitirá que toda tu aplicación tenga acceso a los proveedores de Riverpod.
    ProviderScope(
      overrides: [
        imageBucketDataSourceProvider.overrideWithValue(imageBucketDataSource),
        postDataSourceProvider.overrideWithValue(postDataSource),
        commentDataSourceProvider.overrideWithValue(commentDataSource),
        userPostsDataSourceProvider.overrideWithValue(userPostsDataSource),
      ],
      child: Consumer(
        builder: (context, ref, child) {
          ref.watch(authRedirectProvider);

          final User? user = FirebaseAuth.instance.currentUser;

          if (user != null) {
            try {
              // Obtiene la información del usuario y sus posts al iniciar la aplicación.
              final getUserUseCase = ref.read(getUserLocalUseCaseProvider);

              final profileNotifier =
                  ref.read(profileNotifierProvider.notifier);
              final getAvatarUseCase = ref.read(avatarGetUseCaseProvider);
              ref.read(userRepositoryProvider).getPosts().then(
                (posts) {
                  profileNotifier.updatePosts(posts);
                },
              );

              getUserUseCase.execute().then((user) {
                profileNotifier.updateUserId(user.userId);
                profileNotifier.updateName(user.name);
                profileNotifier.updateEmail(user.email);
                profileNotifier.updateUserName(user.username);
                profileNotifier.updateAge(user.birthDate);
                profileNotifier.updateConnectionsCount(user.connectionsCount);

                if (fcmToken != user.fcmToken) {
                  ref
                      .read(userRepositoryProvider)
                      .updateUserFCMToken(fcmToken!);
                  ref
                      .read(usersRepositoryProvider)
                      .updateUserFCMToken(user, fcmToken);
                }
              });

              getAvatarUseCase.execute(userName).then((avatar) {
                profileNotifier.updateImage(avatar);
              });
            } catch (e) {
              print('Error: $e');
            }
          }

          return const MyApp();
        },
      ),
    ),
  );

  // Escucha los cambios en la autenticación de Firebase.
  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (user == null) {
      logger.info('No user is signed in.');
    } else {
      logger.info('User is signed in. User details: $user');
    }
  });
}
