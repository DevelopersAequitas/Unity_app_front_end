import 'dart:io';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/post_ask_entity.dart';

abstract class PostAskEvent extends Equatable {
  const PostAskEvent();

  @override
  List<Object?> get props => [];
}

class FetchMyAsksEvent extends PostAskEvent {
  const FetchMyAsksEvent();
}

class SubmitPostAskEvent extends PostAskEvent {
  final PostAskEntity entity;
  final File? attachment;

  const SubmitPostAskEvent(this.entity, {this.attachment});

  @override
  List<Object?> get props => [entity, attachment];
}

class CompleteAskEvent extends PostAskEvent {
  final String id;
  final String? subject;

  const CompleteAskEvent(this.id, {this.subject});

  @override
  List<Object?> get props => [id, subject];
}

class FilterAsksEvent extends PostAskEvent {
  final String filter; // 'all', 'open', 'completed'

  const FilterAsksEvent(this.filter);

  @override
  List<Object?> get props => [filter];
}
