import 'package:chatters_2/API/api.dart';
import 'package:chatters_2/Screens/splash_screen.dart';
import 'package:chatters_2/core/network.dart';
import 'package:chatters_2/core/repository/user_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:http/http.dart' as http;

APIs obj = APIs();

void main() async {
  final UserRepository userRepository = UserRepository(
    userApiClient: UserApiClient(
      httpClient: http.Client(),
    ),
  );

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await _initializeFiebase();
  runApp(MyApp(
    userRepository: userRepository,
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
  const MyApp({super.key, required this.userRepository});
  final UserRepository userRepository;
  // This widget is the root of your application.
  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     debugShowCheckedModeBanner: false,
  //       title: 'Chatter',
  //       theme: ThemeData(
  //         useMaterial3: false,
  //         appBarTheme: const AppBarTheme(
  //             centerTitle: true,
  //             elevation: 1,
  //             titleTextStyle: TextStyle(
  //                 color: Colors.black,
  //                 fontWeight: FontWeight.normal,
  //                 fontSize: 19),
  //             backgroundColor: Colors.white,
  //             iconTheme: IconThemeData(color: Colors.black)),
  //       ),
  //       home:  SplashScreen(userRepository: userRepository,));
  // }
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => obj),
      ],
      child: MaterialApp(
          title: 'Chatter',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: false,
            appBarTheme: const AppBarTheme(
                centerTitle: true,
                elevation: 1,
                titleTextStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 19),
                backgroundColor: Colors.white,
                iconTheme: IconThemeData(color: Colors.black)),
          ),
          home: SplashScreen(
            userRepository: userRepository,
          )),
    );
  }
}
