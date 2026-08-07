import 'package:trucky/core/database/client_supp_table.dart';
import 'package:trucky/domain/entities/client_supp_entity.dart';

/// SQLite row mirror of `client_supp_table`.
///
/// Plain Dart class — no codegen. `fromMap` / `toMap` are 1:1 with the
/// column constants in `ClientSuppTable` so a renamed column becomes a compile
/// error here, not a silent runtime bug.
class ClientSuppModel {
  const ClientSuppModel({
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

  factory ClientSuppModel.fromMap(Map<String, Object?> map) {
    return ClientSuppModel(
      id: map[ClientSuppTable.id] as int?,
      userId: map[ClientSuppTable.userId] as int,
      name: map[ClientSuppTable.entityName] as String,
      role: map[ClientSuppTable.role] as String,
      phoneNumber: map[ClientSuppTable.phoneNumber] as String?,
      gpsLocation: map[ClientSuppTable.gpsLocation] as String?,
      isSynced: (map[ClientSuppTable.isSynced] as int) == 1,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        map[ClientSuppTable.createdAt] as int,
      ),
      updatedAt: map[ClientSuppTable.updatedAt] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(
              map[ClientSuppTable.updatedAt] as int,
            ),
    );
  }

  Map<String, Object?> toMap() => {
    if (id != null) ClientSuppTable.id: id,
    ClientSuppTable.userId: userId,
    ClientSuppTable.entityName: name,
    ClientSuppTable.role: role,
    ClientSuppTable.phoneNumber: phoneNumber,
    ClientSuppTable.gpsLocation: gpsLocation,
    ClientSuppTable.isSynced: isSynced ? 1 : 0,
    ClientSuppTable.createdAt: createdAt.millisecondsSinceEpoch,
    ClientSuppTable.updatedAt: updatedAt?.millisecondsSinceEpoch,
  };

  ClientSuppEntity toEntity() => ClientSuppEntity(
    id: id,
    userId: userId,
    name: name,
    role: role,
    phoneNumber: phoneNumber,
    gpsLocation: gpsLocation,
    isSynced: isSynced,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  factory ClientSuppModel.fromEntity(ClientSuppEntity entity) =>
      ClientSuppModel(
        id: entity.id,
        userId: entity.userId,
        name: entity.name,
        role: entity.role,
        phoneNumber: entity.phoneNumber,
        gpsLocation: entity.gpsLocation,
        isSynced: entity.isSynced,
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
      );
}