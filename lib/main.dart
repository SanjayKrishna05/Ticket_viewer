import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticket_viewer/view_models/user_view_model.dart';
import 'package:ticket_viewer/view_models/auth_view_model.dart';
import 'package:ticket_viewer/view_models/ticket_view_model.dart';
import 'package:ticket_viewer/views/auth/login_view.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => UserViewModel()),
        ChangeNotifierProvider(create: (_) => TicketViewModel()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginView(),
    );
  }
}
