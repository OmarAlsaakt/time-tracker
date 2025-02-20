class TimeEntry {
  final String id;
  final String projectId; // معرف المشروع
  final String taskId; // معرف المهمة
  final double totalTime; // الوقت الإجمالي
  final DateTime date; // تاريخ الإدخال
  final String notes; // ملاحظات

  TimeEntry({
    required this.id,
    required this.projectId,
    required this.taskId,
    required this.totalTime,
    required this.date,
    required this.notes,
  });

  // تحويل كائن JSON إلى مثيل من TimeEntry
  factory TimeEntry.fromJson(Map<String, dynamic> json) {
    return TimeEntry(
      id: json['id'],
      projectId: json['projectId'],
      taskId: json['taskId'],
      totalTime: json['totalTime'],
      date: DateTime.parse(json['date']),
      notes: json['notes'],
    );
  }

  // تحويل مثيل من TimeEntry إلى كائن JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'projectId': projectId,
      'taskId': taskId,
      'totalTime': totalTime,
      'date': date.toIso8601String(),
      'notes': notes,
    };
  }
}
