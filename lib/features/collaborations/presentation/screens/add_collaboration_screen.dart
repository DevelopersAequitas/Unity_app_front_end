import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/app_common_bar.dart';
import '../../../../core/widgets/app_gradient_background.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/responsive_container.dart';
import '../bloc/collaborations_bloc.dart';
import '../bloc/collaborations_event.dart';
import '../bloc/collaborations_state.dart';
import '../widgets/collaboration_form.dart';

class AddCollaborationScreen extends StatefulWidget {
  const AddCollaborationScreen({super.key});

  @override
  State<AddCollaborationScreen> createState() => _AddCollaborationScreenState();
}

class _AddCollaborationScreenState extends State<AddCollaborationScreen> {
  @override
  void initState() {
    super.initState();
    // Ensure types and industries are loaded
    final state = context.read<CollaborationsBloc>().state;
    if (state.industries.isEmpty || state.collaborationTypes.isEmpty) {
      context.read<CollaborationsBloc>().add(const LoadCollaborationsInitialData());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CollaborationsBloc, CollaborationsState>(
      listenWhen: (prev, curr) =>
          prev.status != curr.status &&
          (curr.status == CollaborationsStatus.success ||
              curr.status == CollaborationsStatus.error),
      listener: (context, state) {
        if (state.status == CollaborationsStatus.success &&
            state.successMessage != null) {
          AppSnackBar.showSuccess(context, state.successMessage!);
          Navigator.pop(context, true);
        } else if (state.status == CollaborationsStatus.error &&
            state.errorMessage != null) {
          AppSnackBar.showError(context, state.errorMessage!);
        }
      },
      child: Scaffold(
        appBar: const AppCommonBar(
          title: 'Post Collaboration',
          showBack: true,
          showSearch: false,
          showNotifications: false,
          showProfile: false,
        ),
        body: const AppGradientBackground(
          child: ResponsiveContainer(
            child: CollaborationForm(),
          ),
        ),
      ),
    );
  }
}
