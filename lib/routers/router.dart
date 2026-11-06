import 'package:kasih/core/loading.dart';
import 'package:kasih/core/widgets/error.dart';
import 'package:kasih/core/widgets/snackbar_custom.dart';
import 'package:kasih/features/authentication/logic/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:kasih/features/authentication/presentation/screens/auth/login_screen.dart';
import 'package:kasih/features/authentication/presentation/screens/local_auth/passcode_screen.dart';
import 'package:kasih/features/authentication/presentation/screens/splash/splash_screen.dart';
import 'package:kasih/features/bottom_navbar/presentation/screens/bottom_navbar.dart';
import 'package:kasih/features/calendar/presentation/screens/calendar_screen.dart';
import 'package:kasih/features/contact/presentation/contact_screen.dart';
import 'package:kasih/features/healthy_book/presentation/screens/healthy_book_screen.dart';
import 'package:kasih/features/onboarding/presentation/screens/onboarding.dart';
import 'package:kasih/features/profile/presentation/screens/parent_profile_screen.dart';
import 'package:kasih/features/vaccination/presentation/screens/vaccination_screen.dart';
import 'package:kasih/routers/auth_local_router.dart';
import 'package:kasih/routers/auth_router.dart';
import 'package:kasih/routers/contact_router.dart';
import 'package:kasih/routers/profile_router.dart';
import 'package:kasih/routers/route_paths/auth_route_paths.dart';
import 'package:kasih/routers/route_paths/root_route_paths.dart';
import 'package:kasih/routers/route_paths/route_paths.dart';
import 'package:kasih/routers/vaccination_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'calendar_router.dart';
import 'healthy_book_router.dart';

final router = GoRouter(
  debugLogDiagnostics: true,
  initialLocation: RootRoutePaths.root.fullPath,
  routes: [
    GoRoute(
      path: RootRoutePaths.root.path,
      builder: (context, state) {
        final error = state.uri.queryParameters['error'];
        final errorCode = state.uri.queryParameters['error_code'];
        final errorDescription = state.uri.queryParameters['error_description'];

        if (error != null && errorCode != null && errorDescription != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            snackbarCustom(errorDescription).show(context);
          });
        }

        return BlocConsumer<AuthenticationBloc, AuthenticationState>(
          listener: (BuildContext context, AuthenticationState state) {
            if (state is AuthenticationError) {
              snackbarCustom(state.message).show(context);
            }
          },
          builder: (context, state) {
            if (state is Uninitialized) {
              return const SplashScreen();
            } else if (state is Loading) {
              return const LoadingScreen();
            } else if (state is Authenticated) {
              return const PasscodeScreen();
            } else if (state is Unauthenticated) {
              if (state.isSeenOnboarding) {
                return const LoginScreen();
              }
              return OnboardScreen();
            } else if (state is AuthenticationError) {
              return const LoginScreen();
            }
            return Container();
          },
        );
      },
    ),
    GoRoute(
      path: RootRoutePaths.auth.path,
      routes: AuthRouter.routes,
      redirect: (_, state) {
        if (state.fullPath == RootRoutePaths.auth.fullPath) {
          return AuthRoutePaths.loginWithSeribaseOauth.fullPath;
        }
        return null;
      },
    ),
    GoRoute(
      path: RootRoutePaths.authLocal.path,
      routes: AuthLocalRouter.routes,
      redirect: (_, state) {
        if (state.fullPath == RootRoutePaths.authLocal.fullPath) {
          return AuthRoutePaths.passcode.fullPath;
        }
        return null;
      },
    ),
    GoRoute(
      path: RootRoutePaths.onboarding.path,
      builder: (_, __) => OnboardScreen(),
    ),
    GoRoute(
      path: RootRoutePaths.splash.path,
      builder: (_, __) => SplashScreen(),
    ),
    GoRoute(
      path: RootRoutePaths.dashboard.path,
      builder: (_, __) => BottomNavbarWrapper(),
      routes: [
        GoRoute(
          path: RootRoutePaths.profile.path,
          builder: (_, __) => ParentProfileScreen(),
          routes: ProfileRouter.routes,
        ),
        GoRoute(
          path: RootRoutePaths.calendar.path,
          builder: (_, __) => const CalendarScreen(),
          routes: CalendarRouter.routes,
        ),
        GoRoute(
          path: RootRoutePaths.vaccination.path,
          builder: (_, __) => VaccinationScreen(),
          routes: VaccinationRouter.routes,
        ),
        GoRoute(
          path: RootRoutePaths.contact.path,
          builder: (_, __) => ContactScreen(),
          routes: ContactRouter.routes,
        ),
        GoRoute(
          path: RootRoutePaths.healthyBook.path,
          builder: (_, state) => HealthyBookScreen(),
          routes: HealthyBookRouter.routes,
        ),
      ],
    ),
    GoRoute(
      path: RoutePaths.error,
      builder: (context, state) {
        final title = state.uri.queryParameters['error'];
        final desc = state.uri.queryParameters['error_description'];

        return Scaffold(
          appBar: AppBar(leading: BackButton()),
          body: ErrorContainer(title: title, message: desc),
        );
      },
    ),
  ],
  errorBuilder: (context, state) {
    return Scaffold(
      appBar: AppBar(leading: BackButton()),
      body: ErrorContainer(
        title: 'Oops! Something went wrong',
        message: state.error?.message,
      ),
    );
  },
);
