import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/bloc/product/products_bloc.dart';
import 'data/bloc/product/products_event.dart';
import 'data/services/product/product_repository.dart';
import 'router.dart';
import 'utility/helper/notification_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationHelper.initLocalNotification();

  // Initialize SharedPreferences and check the login state
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ProductsBloc(ProductRepository())..add(LoadProductsEvent()),
      child: MaterialApp.router(
        routerConfig: createRouter(isLoggedIn),
      ),
    );
  }
}
