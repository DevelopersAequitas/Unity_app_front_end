import '../../../../core/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_ask_history_usecase.dart';
import '../../domain/entities/ask_item_entity.dart';
import '../bloc/my_asks/my_asks_bloc.dart';
import '../bloc/my_asks/my_asks_event.dart';
import '../bloc/my_asks/my_asks_state.dart';
import '../widgets/ask_history_timeline_sheet.dart';
import '../widgets/my_ask_card.dart';

class MyAsksScreen extends StatefulWidget {
  const MyAsksScreen({super.key});

  @override
  State<MyAsksScreen> createState() => _MyAsksScreenState();
}

class _MyAsksScreenState extends State<MyAsksScreen> {
  static const _flows = [
    {'label': 'All Requests', 'value': 'all'},
    {'label': 'Collaboration', 'value': 'collaboration'},
    {'label': 'Referral', 'value': 'referral'},
    {'label': 'Help', 'value': 'help'},
  ];

  static const _statuses = [
    {'label': 'All Statuses', 'value': 'all'},
    {'label': 'Open', 'value': 'open'},
    {'label': 'In Progress', 'value': 'in_progress'},
    {'label': 'Fulfilled', 'value': 'fulfilled'},
    {'label': 'Closed', 'value': 'closed'},
  ];

  void _onMatchesTap(AskItemEntity ask) {
    Navigator.of(context).pushNamed(
      AppRoutes.askMatches,
      arguments: {
        'askId': ask.id,
        'flowName': ask.flowName,
        'title': ask.title,
      },
    );
  }

  void _onTimelineTap(AskItemEntity ask) {
    final useCase = RepositoryProvider.of<GetAskHistoryUseCase>(context);
    AskHistoryTimelineSheet.show(
      context,
      ask: ask,
      getAskHistoryUseCase: useCase,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final titleColor = isDark ? Colors.white : const Color(0xFF0F172A);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: titleColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'My Requests & Asks',
          style: TextStyle(
            color: titleColor,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(88),
          child: Column(
            children: [
              _FilterRow(
                items: _flows,
                selectedKey: (context.watch<MyAsksBloc>().state).selectedFlow,
                onSelect: (val) => context.read<MyAsksBloc>().add(
                  MyAsksFetchRequested(flow: val),
                ),
              ),
              _FilterRow(
                items: _statuses,
                selectedKey: (context.watch<MyAsksBloc>().state).selectedStatus,
                onSelect: (val) => context.read<MyAsksBloc>().add(
                  MyAsksFetchRequested(status: val),
                ),
              ),
              const SizedBox(height: 6),
            ],
          ),
        ),
      ),
      body: BlocBuilder<MyAsksBloc, MyAsksState>(
        builder: (context, state) {
          if (state.status == MyAsksStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Color(0xFF0E7A68),
              ),
            );
          }
          if (state.status == MyAsksStatus.error) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      state.errorMessage ?? 'Failed to load requests.',
                      style: TextStyle(color: titleColor, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0E7A68),
                      ),
                      onPressed: () => context.read<MyAsksBloc>().add(
                        const MyAsksFetchRequested(),
                      ),
                      child: const Text(
                        'Retry',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          if (state.asks.isEmpty) {
            return RefreshIndicator(
              color: const Color(0xFF0E7A68),
              onRefresh: () async =>
                  context.read<MyAsksBloc>().add(const MyAsksFetchRequested()),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.25),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 48,
                          color: isDark ? Colors.white38 : Colors.black26,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No requests found for selected filters',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark ? Colors.white60 : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return RefreshIndicator(
            color: const Color(0xFF0E7A68),
            onRefresh: () async =>
                context.read<MyAsksBloc>().add(const MyAsksFetchRequested()),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              itemCount: state.asks.length,
              itemBuilder: (context, index) {
                final ask = state.asks[index];
                return MyAskCard(
                  ask: ask,
                  onTap: () => _onMatchesTap(ask),
                  onTimelineTap: () => _onTimelineTap(ask),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _FilterRow extends StatelessWidget {
  final List<Map<String, String>> items;
  final String selectedKey;
  final ValueChanged<String> onSelect;

  const _FilterRow({
    required this.items,
    required this.selectedKey,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final item = items[index];
          final isSelected = item['value'] == selectedKey;
          return ChoiceChip(
            label: Text(
              item['label']!,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : null,
              ),
            ),
            selected: isSelected,
            selectedColor: const Color(0xFF0E7A68),
            onSelected: (_) => onSelect(item['value']!),
          );
        },
      ),
    );
  }
}
