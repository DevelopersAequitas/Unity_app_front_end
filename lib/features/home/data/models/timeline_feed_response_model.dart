import '../../domain/entities/timeline_pagination_entity.dart';
import 'timeline_item_model.dart';

class TimelineFeedResponseModel {
  final List<TimelineItemModel> items;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;
  final Map<String, dynamic>? rawJson;

  const TimelineFeedResponseModel({
    required this.items,
    this.currentPage = 1,
    this.lastPage = 1,
    this.perPage = 20,
    this.total = 0,
    this.rawJson,
  });

  factory TimelineFeedResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    List<TimelineItemModel> itemsList = [];
    int curPage = 1;
    int lPage = 1;
    int pPage = 20;
    int tot = 0;

    if (data is Map<String, dynamic>) {
      final rawItems = (data['items'] ?? data['data']) as List?;
      if (rawItems != null) {
        itemsList = rawItems
            .whereType<Map<String, dynamic>>()
            .map((e) => TimelineItemModel.fromJson(e))
            .toList();
      }

      final pag = data['pagination'] as Map<String, dynamic>?;
      if (pag != null) {
        curPage = (pag['current_page'] as num?)?.toInt() ?? 1;
        lPage = (pag['last_page'] as num?)?.toInt() ?? 1;
        pPage = (pag['per_page'] as num?)?.toInt() ?? 20;
        tot = (pag['total'] as num?)?.toInt() ?? itemsList.length;
      } else {
        curPage = (data['current_page'] as num?)?.toInt() ?? 1;
        lPage = (data['last_page'] as num?)?.toInt() ?? 1;
        pPage = (data['per_page'] as num?)?.toInt() ?? 20;
        tot = (data['total'] as num?)?.toInt() ?? itemsList.length;
      }
    } else if (data is List) {
      itemsList = data
          .whereType<Map<String, dynamic>>()
          .map((e) => TimelineItemModel.fromJson(e))
          .toList();
      tot = itemsList.length;
    }

    return TimelineFeedResponseModel(
      items: itemsList,
      currentPage: curPage,
      lastPage: lPage,
      perPage: pPage,
      total: tot,
      rawJson: json,
    );
  }

  TimelinePaginationEntity toPaginationEntity() {
    return TimelinePaginationEntity(
      currentPage: currentPage,
      lastPage: lastPage,
      perPage: perPage,
      total: total,
    );
  }
}
