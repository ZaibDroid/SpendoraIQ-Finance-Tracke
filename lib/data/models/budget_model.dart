class BudgetModel {
  String id;

  String category;

  double limit;

  int month;

  int year;

  BudgetModel({
    required this.id,
    required this.category,
    required this.limit,
    required this.month,
    required this.year,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'category': category,
        'limit': limit,
        'month': month,
        'year': year,
      };

  factory BudgetModel.fromJson(Map<String, dynamic> json) => BudgetModel(
        id: json['id'],
        category: json['category'],
        limit: (json['limit'] as num).toDouble(),
        month: json['month'],
        year: json['year'],
      );
}
