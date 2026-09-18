class VyapaarJagatStoryStatusEntity {
  final String? status;
  final String? storyLink;
  final String? message;
  final bool isSubmitted;

  const VyapaarJagatStoryStatusEntity({
    this.status,
    this.storyLink,
    this.message,
    this.isSubmitted = false,
  });
}
