// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:vms/widgets/bottom_nav_bar/presentation/widgets/vms_bottom_nav_bar.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

  
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: VmsBottamNavBar(),
//     );
//   }
// }



// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:provider/provider.dart';
// import 'package:vms/widgets/bottom_nav_bar/presentation/widgets/vms_bottom_nav_bar.dart';
// import 'providers/app_state_provider.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => AppStateProvider()),
//       ],
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         title: 'Flutter Demo',
//         theme: ThemeData(
//           colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//           useMaterial3: true,
//         ),
//         home: const VmsBottamNavBar(),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:vms/providers/define_yourself_provider.dart';

import 'package:vms/providers/nav_provider.dart';
import 'package:vms/providers/visit_log_provider.dart';
import 'package:vms/providers/visit_provider.dart';
import 'package:vms/providers/visit_request_provider.dart';
import 'package:vms/screens/role_selection_screen.dart';
import 'package:vms/widgets/bottom_nav_bar/presentation/widgets/vms_bottom_nav_bar.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavProvider()),
        ChangeNotifierProvider(create: (_) => VisitProvider()),
        ChangeNotifierProvider(create: (_) => VisitLogProvider()),
        ChangeNotifierProvider(create: (_) => VisitRequestProvider()),
        ChangeNotifierProvider(create: (_) => RoleProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Visitor Management System',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      // home: const DefineYourselfScreen(),
      home: VmsBottomNavBar(),
    );
  }
}
