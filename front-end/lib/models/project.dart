class Project {
  final int id; // 🔹 changer String en int
  final String name;
  final String status;
  final double amount;
  final DateTime createdAt;

  Project({
    required this.id,
    required this.name,
    required this.status,
    required this.amount,
    required this.createdAt,
  });

  factory Project.fromJson(Map<String, dynamic> json) => Project(
    id: json['id'], // Flutter convertit automatiquement en int
    name: json['name'],
    status: json['status'],
    amount: (json['amount'] as num).toDouble(),
    createdAt: DateTime.parse(json['createdAt']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'status': status,
    'amount': amount,
    'createdAt': createdAt.toIso8601String(),
  };
}