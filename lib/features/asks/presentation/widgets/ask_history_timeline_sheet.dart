import 'package:flutter/material.dart';
import '../../domain/entities/ask_history_item_entity.dart';
import '../../domain/entities/ask_item_entity.dart';
import '../../domain/usecases/get_ask_history_usecase.dart';

class AskHistoryTimelineSheet extends StatelessWidget {
  final AskItemEntity ask;
  final GetAskHistoryUseCase getAskHistoryUseCase;

  const AskHistoryTimelineSheet({
    super.key,
    required this.ask,
    required this.getAskHistoryUseCase,
  });

  static void show(
    BuildContext context, {
    required AskItemEntity ask,
    required GetAskHistoryUseCase getAskHistoryUseCase,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AskHistoryTimelineSheet(
        ask: ask,
        getAskHistoryUseCase: getAskHistoryUseCase,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final titleColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final subColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.75),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? Colors.white24 : Colors.black12,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Request History & Timeline',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: titleColor),
          ),
          Text(ask.title, style: TextStyle(fontSize: 13, color: subColor), maxLines: 1),
          const SizedBox(height: 16),
          Expanded(
            child: FutureBuilder<List<AskHistoryItemEntity>>(
              future: getAskHistoryUseCase(ask.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(strokeWidth: 2));
                }
                final history = snapshot.data ?? [];
                if (history.isEmpty) {
                  return Center(
                    child: Text(
                      'No status transitions recorded yet.',
                      style: TextStyle(color: subColor, fontSize: 13.5),
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: history.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = history[index];
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.only(top: 5, right: 12),
                          decoration: const BoxDecoration(
                            color: Color(0xFF0E7A68),
                            shape: BoxShape.circle,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.toStatus.toUpperCase().replaceAll('_', ' '),
                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w500,
                                  color: titleColor,
                                ),
                              ),
                              if (item.reason != null && item.reason!.isNotEmpty)
                                Text(item.reason!, style: TextStyle(fontSize: 12, color: subColor)),
                              if (item.createdAt != null)
                                Text(item.createdAt!, style: TextStyle(fontSize: 11, color: subColor)),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
