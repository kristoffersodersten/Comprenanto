import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/routes/app_router.dart';
import 'notifiers/transcription_notifier.dart';
import 'core/di/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => serviceLocator<TranscriptionNotifier>(),
        ),
      ],
      child: MaterialApp.router(
        title: 'Comprenanto',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routerDelegate: appRouter.routerDelegate,
        routeInformationParser: appRouter.routeInformationParser,
      ),
    );
  }
}
