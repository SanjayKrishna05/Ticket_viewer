class Ticket {
  final String id;
  final String title;
  final String description;
  final String customerName;
  String status;
  DateTime lastUpdated;

  Ticket({
    required this.id,
    required this.title,
    required this.description,
    required this.customerName,
    required this.status,
    required this.lastUpdated,
  });
}
