/// Model representing a treasury / cash-flow entry.
class TreasuryModel {
  const TreasuryModel({
    required this.img,
    required this.name,
    required this.date,
    required this.time,
    required this.amount,
    required this.status,
  });

  final String img;
  final String name;
  final String date;
  final String time;

  /// Amount as a numeric string (may carry a +/- sign for visual intent);
  /// sign is otherwise conveyed through the status and list color.
  final String amount;
  final String status;

  TreasuryModel copyWith({
    String? img,
    String? name,
    String? date,
    String? time,
    String? amount,
    String? status,
  }) {
    return TreasuryModel(
      img: img ?? this.img,
      name: name ?? this.name,
      date: date ?? this.date,
      time: time ?? this.time,
      amount: amount ?? this.amount,
      status: status ?? this.status,
    );
  }
}