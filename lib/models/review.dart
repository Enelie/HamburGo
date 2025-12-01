class Review {
  final String id;
  final String orderId;
  final int rating; // 1-5
  final String comment;
  final DateTime date;

  Review({
    required this.id,
    required this.orderId,
    required this.rating,
    required this.comment,
    required this.date,
  });

  Map<String,dynamic> toMap() => {
    'id': id,
    'orderId': orderId,
    'rating': rating,
    'comment': comment,
    'date': date.toIso8601String(),
  };
}
