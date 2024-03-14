import 'package:hive/hive.dart';

part 'id.g.dart';

@HiveType(typeId: 3)
class Id {
  Id({
    required this.cardNumber,
    required this.Addres,
    required this.ExpiryDate,
    required this.cardHolderName,
    // ignore: non_constant_identifier_names
    required this.DateOfBirth,
    this.cardType,
  });

  @HiveField(0)
  String cardNumber;

  @HiveField(1)
  String ExpiryDate;

  @HiveField(2)
  String cardHolderName;
  @HiveField(3)
  String Addres;
  @HiveField(4)
  String DateOfBirth;

  @HiveField(5, defaultValue: 'other ')
  String? cardType;
}
