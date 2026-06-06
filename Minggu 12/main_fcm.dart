import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(
    RemoteMessage message) async {
  await Firebase.initializeApp();

  print("Pesan masuk di background: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDrZZS4AWgd5zxztd4kpVLUwjPRS4cgI6Y",
      appId: "1:7446813326:android:4f1c9a03a7eb1375b5f1df",
      messagingSenderId: "7446813326",
      projectId: "laprak-pertemuan-12",
      storageBucket: "laprak-pertemuan-12.firebasestorage.app",
    ),
  );

  FirebaseMessaging.onBackgroundMessage(
    _firebaseMessagingBackgroundHandler,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FCM Manual Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const NotificationScreen(),
    );
  }
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() =>
      _NotificationScreenState();
}

class _NotificationScreenState
    extends State<NotificationScreen> {
  String _fcmToken = "Menunggu Token...";

  @override
  void initState() {
    super.initState();
    _setupFirebaseMessaging();
  }

  Future<void> _setupFirebaseMessaging() async {
    try {
      FirebaseMessaging messaging =
          FirebaseMessaging.instance;

      NotificationSettings settings =
          await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus ==
          AuthorizationStatus.authorized) {
        print('Izin diberikan');
      }

      String? token = await messaging.getToken();

      setState(() {
        _fcmToken =
            token ?? "Gagal mendapatkan token";
      });

      print("FCM Token Asli: $token");

      FirebaseMessaging.onMessage.listen(
        (RemoteMessage message) {
          if (message.notification != null) {
            ScaffoldMessenger.of(context)
                .showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(
                      Icons.notifications_active,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        mainAxisSize:
                            MainAxisSize.min,
                        children: [
                          Text(
                            message.notification!
                                    .title ??
                                'Notifikasi',
                            style:
                                const TextStyle(
                              fontWeight:
                                  FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            message.notification!
                                    .body ??
                                '',
                            style:
                                const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                duration:
                    const Duration(seconds: 5),
                backgroundColor: Colors.teal,
                behavior:
                    SnackBarBehavior.floating,
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                    10,
                  ),
                ),
              ),
            );
          }
        },
      );
    } catch (e) {
      setState(() {
        _fcmToken = "Error Sistem:\n$e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'FCM Tanpa CLI - Wafiq',
        ),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding:
            const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              const Text(
                'FCM Token Anda:',
                style: TextStyle(
                  fontWeight:
                      FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding:
                    const EdgeInsets.all(
                  12,
                ),
                decoration: BoxDecoration(
                  color:
                      Colors.teal.shade50,
                  borderRadius:
                      BorderRadius
                          .circular(8),
                  border: Border.all(
                    color: Colors
                        .teal.shade200,
                  ),
                ),
                child: SelectableText(
                  _fcmToken,
                  textAlign:
                      TextAlign.center,
                  style:
                      const TextStyle(
                    color: Colors.teal,
                    fontWeight:
                        FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Gunakan token ini untuk testing di Firebase Console.',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                ),
                textAlign:
                    TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}