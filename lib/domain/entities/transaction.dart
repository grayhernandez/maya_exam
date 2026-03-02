class Transaction {
  final int id;
  final double amount;
  final String title;
  final DateTime date;

  Transaction({
    required this.id,
    required this.amount,
    required this.title,
    required this.date,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as int,
      amount: (json['amount'] as num).toDouble(),
      title: json['title'] as String? ?? 'Money Transfer',
      date: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'amount': amount,
        'userId': 1,
      };
}
