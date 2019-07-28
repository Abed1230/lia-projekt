class Progress {
  final Map<String, bool> chapters;
  final Map<String, bool> tasks;

  Progress({this.chapters, this.tasks});

  factory Progress.fromMap(Map data) {
    if (data == null) return null;

    return new Progress(
        chapters: data['chapters']?.cast<String, bool>(),
        tasks: data['tasks']?.cast<String, bool>());
  }

  bool isChapterCompleted(String id) {
    if (chapters != null && chapters[id] != null)
      return chapters[id];
    else 
      return false;
  }

  bool isTaskCompleted(String id) {
    if (tasks != null && tasks[id] != null)
      return tasks[id];
    else 
      return false;
  }

  bool isAllTasksCompleted(List<String> taskIds)  {
    int count = 0;
    for (String id in taskIds) {
      if (tasks[id] != null && tasks[id])
        count++;
    }
    return count == taskIds.length;
  }
}