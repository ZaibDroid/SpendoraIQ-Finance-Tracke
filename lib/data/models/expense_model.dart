class ExpenseModel {
  String id;

  String title;

  double amount;

  String category;

  DateTime date;

  String? notes;

  bool isIncome;

  bool isRecurring;

  String? recurringId;

  ExpenseModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    this.notes,
    this.isIncome = false,
    this.isRecurring = false,
    this.recurringId,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'amount': amount,
        'category': category,
        'date': date.toIso8601String(),
        'notes': notes,
        'isIncome': isIncome,
        'isRecurring': isRecurring,
        'recurringId': recurringId,
      };

  factory ExpenseModel.fromJson(Map<String, dynamic> json) => ExpenseModel(
        id: json['id'],
        title: json['title'],
        amount: (json['amount'] as num).toDouble(),
        category: json['category'],
        date: DateTime.parse(json['date']),
        notes: json['notes'],
        isIncome: json['isIncome'] ?? false,
        isRecurring: json['isRecurring'] ?? false,
        recurringId: json['recurringId'],
      );

  ExpenseModel copyWith({
    String? id,
    String? title,
    double? amount,
    String? category,
    DateTime? date,
    String? notes,
    bool? isIncome,
    bool? isRecurring,
    String? recurringId,
  }) {
    return ExpenseModel(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
      notes: notes ?? this.notes,
      isIncome: isIncome ?? this.isIncome,
      isRecurring: isRecurring ?? this.isRecurring,
      recurringId: recurringId ?? this.recurringId,
    );
  }
}
