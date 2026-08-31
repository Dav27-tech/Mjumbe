import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mjumbe/app/theme/app_theme.dart';
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
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Material(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                    color: AppTheme.primaryNeutral,
                    child: const Text(
                      'MODE HORS-LIGNE ACTIVÉ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                      ),
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
