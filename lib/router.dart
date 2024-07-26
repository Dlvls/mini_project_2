import 'package:go_router/go_router.dart';
import 'package:mini_project_2/product/detail/detail_page.dart';
import 'package:mini_project_2/product/home_page.dart';
import 'package:mini_project_2/profile/profile_page.dart';
import 'package:mini_project_2/splash_page.dart';
import 'package:mini_project_2/try.dart';

import 'auth/login_page.dart';
import 'auth/register_page.dart';
import 'cart/cart_page.dart';
import 'cart/check_out_page.dart';
import 'cart/confirm_order.dart';
import 'cart/shipping_page.dart';
import 'cart/transfer.dart';

GoRouter createRouter(bool isLoggedIn) {
  return GoRouter(
    initialLocation: '/', // Set initial location to SplashPage
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/cart',
        builder: (context, state) => const CartPage(),
      ),
      GoRoute(
        path: '/checkout',
        builder: (context, state) {
          final totalPrice = state.extra as double? ?? 0.0;
          return CheckOutPage(totalPrice: totalPrice);
        },
      ),
      GoRoute(
        path: '/transfer',
        builder: (context, state) {
          final double totalPrice = (state.extra
                  as Map<String, dynamic>?)?['totalPrice'] as double? ??
              0.0;
          return TransferPage(totalPrice: totalPrice);
        },
      ),
      GoRoute(
        path: '/shipping',
        builder: (context, state) {
          final totalPrice = state.extra as double? ?? 0.0;
          return ShippingPage(totalPrice: totalPrice);
        },
      ),
      GoRoute(
        path: '/confirm_order',
        builder: (context, state) => const ConfirmOrder(),
      ),
      GoRoute(
        path: '/try',
        builder: (context, state) => const TryPage(),
      ),
      GoRoute(
        path: '/detail/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'];
          return DetailPage(
              productId: int.parse(
                  id!)); // Make sure DetailPage accepts a productId parameter
        },
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfilePage(),
      ),
    ],
  );
}
