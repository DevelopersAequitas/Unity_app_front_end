import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/app_common_bar.dart';
import '../../../../core/widgets/app_gradient_background.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/responsive_container.dart';
import '../bloc/requirements_bloc.dart';
import '../bloc/requirements_event.dart';
import '../bloc/requirements_state.dart';
import '../widgets/requirement_form.dart';

class PostAskFormScreen extends StatelessWidget {
  const PostAskFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<RequirementsBloc, RequirementsState>(
      listenWhen: (prev, curr) =>
          prev.status != curr.status &&
          (curr.status == RequirementsStatus.success ||
              curr.status == RequirementsStatus.error),
      listener: (context, state) {
        if (state.status == RequirementsStatus.success &&
            state.successMessage != null) {
          AppSnackBar.showSuccess(context, state.successMessage!);
        } else if (state.status == RequirementsStatus.error &&
            state.errorMessage != null) {
          AppSnackBar.showError(context, state.errorMessage!);
        }
      },
      child: Scaffold(
        appBar: AppCommonBar(
          title: 'Post an Ask',
          showBack: true,
          showSearch: false,
          showNotifications: false,
          showProfile: false,
        ),
        body: AppGradientBackground(
          child: ResponsiveContainer(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(top: 8, bottom: 24),
              child: RequirementForm(
                onSuccess: () {
                  context
                      .read<RequirementsBloc>()
                      .add(const FetchMyRequirementsEvent());
                  context
                      .read<RequirementsBloc>()
                      .add(const FetchOpenRequirementsEvent());
                  Navigator.of(context).pop(true);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
