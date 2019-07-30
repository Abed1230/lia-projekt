class CompletionStatus {
  final Map<String, bool> chapters;
  final Map<String, bool> tasks;

  CompletionStatus({this.chapters, this.tasks});

  factory CompletionStatus.fromMap(Map data) {
    if (data == null) return null;

    return new CompletionStatus(
        chapters: data['chapters']?.cast<String, bool>(),
        tasks: data['tasks']?.cast<String, bool>());
  }
}