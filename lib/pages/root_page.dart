import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/cubit/auth/auth_cubit.dart';
import 'package:my_project/cubit/auth/auth_state.dart';
import 'package:my_project/pages/home_page.dart';
import 'package:my_project/pages/login_page.dart';
import 'package:my_project/providers/wifi_provider.dart';
import 'package:my_project/services/notification_service.dart';

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<AuthCubit>(),
      child: BlocListener<AuthCubit, AuthState>(
        listenWhen: (prev, curr) {
          return prev.isLoggin != curr.isLoading;
        },
        listener: (context, state) {
          final wifiProvider = context.read<WiFiProvider>();
            wifiProvider.init();

          if (!wifiProvider.isConnected && state.isLoggin) {
            NotificationService.show('No internet connection');
          }
        },
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.green),
              );
            }

            return state.isLoggin ? const HomePage() : const LoginPage();
          },
        ),
      ),
    );
  }
}
