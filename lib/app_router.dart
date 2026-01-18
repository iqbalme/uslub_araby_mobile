
import 'package:go_router/go_router.dart';
import 'package:uslub_araby/screens/uslub_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const UslubScreen(),
    ),
  ],
);
