import 'package:kasih/routers/route_paths/root_route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/constant.dart';
import '../../../../core/widgets/snackbar_custom.dart';
import '../../../home/presentation/screens/home_screen.dart';
import '../../../message/presentation/screens/pesan_page.dart';
import '../../../authentication/logic/bloc/authentication_bloc/authentication_bloc.dart';
import '../../../profile/presentation/screens/profile_screen.dart';
import '../../logic/buttom_navbar/bottom_navbar_cubit.dart';

class BottomNavbarWrapper extends StatelessWidget {
  const BottomNavbarWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          context.pushReplacement(RootRoutePaths.root.fullPath);
          snackbarCustom(AppConstant.LOGOUT_SUCCEED);
        }
      },
      child: BlocProvider(
        create: (context) => BottomNavbarCubit(),
        child: Scaffold(
          extendBodyBehindAppBar: false,
          body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
              if (state is Authenticated) {
                return BlocBuilder<BottomNavbarCubit, BottomNavbarState>(
                  builder: (contextNavbar, stateNavbar) {
                    if (stateNavbar is BottomNavbarHome) {
                      return const HomeScreen();
                    } else if (stateNavbar is BottomNavbarProfile) {
                      return const ProfilePage();
                    } else if (stateNavbar is BottomNavbarMessage) {
                      return PesanPage();
                    } else {
                      return Placeholder();
                    }
                  },
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
          bottomNavigationBar:
              BlocBuilder<BottomNavbarCubit, BottomNavbarState>(
                builder: (context, state) {
                  return BottomNavigationBar(
                    showSelectedLabels: true,
                    showUnselectedLabels: true,
                    selectedItemColor: Colors.black,
                    unselectedItemColor: Colors.grey[600],
                    selectedLabelStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    unselectedLabelStyle: const TextStyle(fontSize: 12),
                    type: BottomNavigationBarType.fixed,
                    currentIndex: state.itemIndex,
                    onTap:
                        (value) =>
                            context.read<BottomNavbarCubit>().navigateTo(value),
                    items: const [
                      BottomNavigationBarItem(
                        icon: FaIcon(
                          FontAwesomeIcons.houseChimneyMedical,
                          size: 20,
                        ),
                        label: 'Beranda',
                      ),
                      BottomNavigationBarItem(
                        icon: FaIcon(FontAwesomeIcons.solidUser, size: 20),
                        label: 'Profil',
                      ),
                      BottomNavigationBarItem(
                        icon: FaIcon(FontAwesomeIcons.solidEnvelope, size: 20),
                        label: 'Pesan',
                      ),
                    ],
                  );
                },
              ),
        ),
      ),
    );
  }
}
