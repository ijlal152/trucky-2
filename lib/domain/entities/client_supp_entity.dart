/// A client or supplier account.
class ClientSuppEntity {
  const ClientSuppEntity({
    this.id,
    required this.userId,
    required this.name,
    required this.role,
    this.phoneNumber,
    this.gpsLocation,
    this.isSynced = false,
    required this.createdAt,
    this.updatedAt,
  });

  final int? id;
  final int userId;
  final String name;
  final String role;
  final String? phoneNumber;
  final String? gpsLocation;
  final bool isSynced;
  final DateTime createdAt;
  final DateTime? updatedAt;
}