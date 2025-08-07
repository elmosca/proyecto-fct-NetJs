import 'package:fct_frontend/features/tasks/domain/entities/task.dart';
import 'package:fct_frontend/features/tasks/presentation/widgets/assign_users_dialog.dart';
import 'package:fct_frontend/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class AssignUsersButton extends StatelessWidget {
  final Task task;
  final int assignedCount;
  final VoidCallback? onPressed;

  const AssignUsersButton({
    super.key,
    required this.task,
    this.assignedCount = 0,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return InkWell(
      onTap: onPressed ?? () => _showAssignUsersDialog(context),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.people,
              size: 16,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 4),
            Text(
              assignedCount > 0 ? '$assignedCount' : l10n.assignUsers,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            if (assignedCount > 0) ...[
              const SizedBox(width: 4),
              Icon(
                Icons.add,
                size: 14,
                color: Theme.of(context).colorScheme.primary,
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showAssignUsersDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AssignUsersDialog(task: task),
    );
  }
}
