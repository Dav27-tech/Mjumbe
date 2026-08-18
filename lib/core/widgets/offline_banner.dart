import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mjumbe/core/utils/connectivity_cubit.dart';

class OfflineBanner extends StatelessWidget {
  final Widget child;
  const OfflineBanner({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityCubit, bool>(
      builder: (context, isOnline) {
        return Stack(
          children: [
            child,
            if (!isOnline)
              SafeArea(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: double.infinity,
                    color: Colors.orangeAccent.withOpacity(0.95),
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    child: const Text(
                      'Vous êtes hors-ligne — certaines fonctionnalités sont limitées.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
