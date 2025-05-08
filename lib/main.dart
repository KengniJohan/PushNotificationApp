import 'package:flutter/material.dart';
import "package:flutter_local_notifications/flutter_local_notifications.dart";
// import 'package:flutter_native_timezone/flutter_native_timezone.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await _configureLocalTimeZone();
  runApp(const MyApp());
}

// Future<void> _configureLocalTimeZone() async {
//   tz.initializeTimeZones();
//   final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
//   tz.setLocalLocation(tz.getLocation(timeZoneName));
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Notification Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Demo Notifications'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  bool _vibrationEnabled = true; // Pour gérer l'état de la vibration

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    // Initialisation pour Android
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(
          'ic_launcher',
        ); // ic_launcher est le nom de l'icone de l'application

    // Initialisation pour iOS
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    // Paramètres d'initialisation globaux
    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    // Initialise le plugin
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (
        NotificationResponse notificationResponse,
      ) {
        // Gestion de la réponse à la notification (quand l'utilisateur clique dessus)
        // Ici, on affiche un message dans la console pour l'exemple
        debugPrint('Notification payload: ${notificationResponse.payload}');
      },
    );
  }

  // Fonction pour afficher une notification
  Future<void> _showNotification({
    required String title,
    required String body,
    String? payload,
    bool playSound = true,
    bool enableVibration = true,
  }) async {
    // Paramètres spécifiques à Android
    AndroidNotificationDetails
    androidNotificationDetails = AndroidNotificationDetails(
      'your_channel_id', // Changer pour un ID de canal unique
      'Your Channel Name', // Changer pour un nom de canal convivial
      channelDescription:
          'Description of your channel', // Changer pour une description du canal
      importance: Importance.max,
      priority: Priority.high,
      playSound: playSound,
      enableVibration: enableVibration,
      //sound:
      //    const RawResourceAndroidNotificationSound('sound'), // Décommenter et ajouter un fichier 'sound.wav' dans android/app/src/main/res/raw/
      ticker: 'ticker',
    );

    // Paramètres spécifiques à iOS
    DarwinNotificationDetails
    iOSNotificationDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound:
          'sound.wav', // Assurez-vous que le fichier son existe dans le projet.  Pour les sons personnalisés sur iOS, ils doivent être ajoutés au projet Xcode.
    );

    // Paramètres de notification globaux
    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iOSNotificationDetails,
    );

    // Affiche la notification
    await flutterLocalNotificationsPlugin.show(
      0, // ID de la notification (doit être unique)
      title,
      body,
      notificationDetails,
      payload:
          payload, // Peut être utilisé pour passer des données à l'application quand l'utilisateur clique sur la notification
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                _showNotification(
                  title: 'Notification Simple',
                  body: 'Ceci est une notification Flutter !',
                  payload: 'simple_notification_payload',
                  playSound: false, // Vous pouvez changer cela
                  enableVibration:
                      _vibrationEnabled, // Utilise l'état de la vibration
                );
              },
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  'Afficher Notification Sans Son',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _showNotification(
                  title: 'Notification avec Son',
                  body: 'Ceci est une notification avec un son personnalisé !',
                  payload: 'sound_notification_payload',
                  playSound: true,
                  enableVibration: _vibrationEnabled,
                );
              },
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  'Afficher Notification Avec Son',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _vibrationEnabled =
                      !_vibrationEnabled; // Inverse l'état de la vibration
                });
                // Affiche un message pour indiquer l'état de la vibration
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Vibration ${_vibrationEnabled ? 'activée' : 'désactivée'}',
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  _vibrationEnabled
                      ? 'Désactiver la Vibration'
                      : 'Activer la Vibration',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
