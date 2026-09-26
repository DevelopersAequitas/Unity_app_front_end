import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/app_common_bar.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../domain/entities/ask_flow_entity.dart';
import '../../domain/entities/ask_type_entity.dart';
import '../bloc/ask_types/ask_types_bloc.dart';
import '../bloc/ask_types/ask_types_event.dart';
import '../bloc/ask_types/ask_types_state.dart';
import '../widgets/ask_bottom_button.dart';
import '../widgets/ask_step_header.dart';
import '../widgets/ask_types_grid.dart';
import '../widgets/ask_types_skeleton.dart';

class AskTypesScreen extends StatefulWidget {
  final AskFlowEntity flow;

  const AskTypesScreen({
    super.key,
    required this.flow,
  });

  @override
  State<AskTypesScreen> createState() => _AskTypesScreenState();
}

class _AskTypesScreenState extends State<AskTypesScreen> {
  AskTypeEntity? _selectedType;

  @override
  void initState() {
    super.initState();
    final flowId = widget.flow.id.isNotEmpty ? widget.flow.id : widget.flow.code;
    context.read<AskTypesBloc>().add(AskTypesFetchRequested(flowId));
  }

  String _getSubtitle() {
    final code = widget.flow.code.toLowerCase().trim();
    if (code == 'collaboration') {
      return 'What kind of collaboration are you looking for?';
    } else if (code == 'referral') {
      return 'What kind of referral are you looking for?';
    } else if (code == 'help') {
      return 'What kind of help are you looking for?';
    }
    return 'What kind of ${widget.flow.name.toLowerCase()} are you looking for?';
  }

  void _onTypeSelected(AskTypeEntity type) {
    Navigator.of(context).pushNamed(
      AppRoutes.askBrief,
      arguments: {
        'flow': widget.flow,
        'type': type,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final subtitleColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final flowId = widget.flow.id.isNotEmpty ? widget.flow.id : widget.flow.code;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppCommonBar(
        title: widget.flow.name,
        showBack: true,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AskStepHeader(
              title: widget.flow.name,
              subtitle: _getSubtitle(),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: BlocBuilder<AskTypesBloc, AskTypesState>(
                builder: (context, state) {
                  if (state.status == AskTypesStatus.loading && state.types.isEmpty) {
                    return const AskTypesSkeleton();
                  }

                  if (state.status == AskTypesStatus.error && state.types.isEmpty) {
                    return AppErrorView(
                      title: 'Unable to Load Categories',
                      message: state.errorMessage ?? 'Please check your connection and try again.',
                      onRetry: () => context
                          .read<AskTypesBloc>()
                          .add(AskTypesFetchRequested(flowId)),
                    );
                  }

                  if (state.types.isEmpty) {
                    return Center(
                      child: Text(
                        'No categories available at the moment.',
                        style: TextStyle(color: subtitleColor, fontSize: 14),
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      context
                          .read<AskTypesBloc>()
                          .add(AskTypesRefreshRequested(flowId));
                    },
                    child: AskTypesGrid(
                      types: state.types,
                      selectedType: _selectedType,
                      onTypeTap: (type) {
                        setState(() {
                          _selectedType = type;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            AskBottomButton(
              label: 'Continue',
              onPressed: _selectedType != null
                  ? () => _onTypeSelected(_selectedType!)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
