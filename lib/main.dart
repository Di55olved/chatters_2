// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chatters_2/Navigaitions/my_navigations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:chatters_2/API/api.dart';
import 'package:chatters_2/core/network.dart';
import 'package:chatters_2/core/repository/user_repo.dart';
import 'firebase_options.dart';

APIs obj = APIs();
UserRepository userRepository = UserRepository(
  userApiClient: UserApiClient(
    httpClient: http.Client(),
  ),
);
void main() async {
  // Initialzie Navigation
  MyRouter router = MyRouter();

  // All the main stuff
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await _initializeFiebase();
  runApp(MyApp(
    userRepository: userRepository,
    router: router.router,
  ));
}

Future<void> _initializeFiebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  var result = await FlutterNotificationChannel.registerNotificationChannel(
    description: 'For Showing Message Notifications',
    id: 'chats',
    importance: NotificationImportance.IMPORTANCE_HIGH,
    name: 'Chats',
  );
  print("\nnotification channel result: $result");
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.userRepository,
    required this.router,
  });
  final UserRepository userRepository;
  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => obj),
        ],
        child: MaterialApp.router(
          title: 'BrieF Chat',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: false,
            appBarTheme: const AppBarTheme(
                centerTitle: true,
                elevation: 1,
                titleTextStyle: TextStyle(color: Colors.black, fontSize: 19),
                backgroundColor: Colors.white,
                iconTheme: IconThemeData(color: Colors.black)),
          ),
          routerConfig: router,
        ));
  }
}
