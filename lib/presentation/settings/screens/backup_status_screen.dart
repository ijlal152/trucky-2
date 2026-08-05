import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trucky/presentation/settings/bloc/settings_bloc.dart';
import 'package:trucky/presentation/settings/bloc/settings_event.dart';
import 'package:trucky/presentation/settings/bloc/settings_state.dart';
import 'package:trucky/presentation/widgets/custom_app_bar.dart';
import 'package:trucky/presentation/widgets/custom_scaffold.dart';

class BackupStatusScreen extends StatelessWidget {
  static const String id = '/settings/backup';

  const BackupStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        final backedUp = state.isBackedUp;
        final when = state.lastBackupAt;

        return CustomScaffold(
          appBar: const CustomAppBar(title: 'Backup Status'),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: Card(
                    elevation: 2,
                    margin: const EdgeInsets.all(20),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: backedUp
                                ? Colors.green.withValues(alpha: 0.15)
                                : Colors.red.withValues(alpha: 0.15),
                            child: Icon(
                              backedUp ? Icons.check_circle : Icons.cancel,
                              size: 36,
                              color: backedUp ? Colors.green : Colors.red,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            backedUp
                                ? 'Data is backed up'
                                : 'Data is NOT backed up',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            when != null
                                ? 'Last backup: ${_fmt(when)}'
                                : 'No backup recorded yet',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.textTheme.bodySmall?.color,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              OutlinedButton.icon(
                                onPressed: () => context
                                    .read<SettingsBloc>()
                                    .add(const CheckBackupStatusEvent()),
                                icon: const Icon(Icons.refresh),
                                label: const Text('Check status'),
                              ),
                              const SizedBox(width: 8),
                              FilledButton.icon(
                                onPressed: state.status == SettingsStatus.backingUp
                                    ? null
                                    : () => context
                                        .read<SettingsBloc>()
                                        .add(const RunBackupEvent()),
                                icon: state.status == SettingsStatus.backingUp
                                    ? const SizedBox(
                                        height: 16,
                                        width: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Icon(Icons.backup),
                                label: Text(
                                  state.status == SettingsStatus.backingUp
                                      ? 'Backing up...'
                                      : 'Backup now',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  static String _fmt(DateTime dt) {
    final d =
        '${dt.year.toString().padLeft(4, '0')}-'
        '${dt.month.toString().padLeft(2, '0')}-'
        '${dt.day.toString().padLeft(2, '0')}';
    final t =
        '${dt.hour.toString().padLeft(2, '0')}:'
        '${dt.minute.toString().padLeft(2, '0')}';
    return '$d $t';
  }
}