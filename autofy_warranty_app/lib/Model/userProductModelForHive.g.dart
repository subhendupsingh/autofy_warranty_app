// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userProductModelForHive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserProductModelForHiveAdapter
    extends TypeAdapter<UserProductModelForHive> {
  @override
  final int typeId = 0;

  @override
  UserProductModelForHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProductModelForHive(
      productName: fields[0] as String?,
      productSKU: fields[1] as String?,
      productImageURL: fields[2] as String?,
      warrantyCode: fields[3] as String?,
      warrantyExpiryDate: fields[4] as String?,
      warrantyStatus: fields[5] as String?,
      numberOfRepairRequestsLeft: fields[6] as int?,
      showRepairButton: fields[7] as bool?,
      purchaseDate: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserProductModelForHive obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.productName)
      ..writeByte(1)
      ..write(obj.productSKU)
      ..writeByte(2)
      ..write(obj.productImageURL)
      ..writeByte(3)
      ..write(obj.warrantyCode)
      ..writeByte(4)
      ..write(obj.warrantyExpiryDate)
      ..writeByte(5)
      ..write(obj.warrantyStatus)
      ..writeByte(6)
      ..write(obj.numberOfRepairRequestsLeft)
      ..writeByte(7)
      ..write(obj.showRepairButton)
      ..writeByte(8)
      ..write(obj.purchaseDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProductModelForHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
