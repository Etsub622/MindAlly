

import 'package:equatable/equatable.dart';
import 'package:front_end/features/profile_therapist/domain/entities/therapist_entity.dart';

class   TherapistModel extends TherapistEntity {

  const TherapistModel({
    required  super.id,
    required  super.name,
    required  super.email,
    required  super.hasPassword,
    required  super.role,
    required super.bio,
    required super.certificate,
    required super.fee,
    required super.rating,
    required super.verified,
    required super.payout,
    super.profilePicture,
        });

  factory TherapistModel.fromJson(Map<String, dynamic> json) {
    return TherapistModel(
      id: json['_id'],
      name: json['FullName'],
      email: json['Email'],
      role: json['Role'] ?? "therapist",
      hasPassword: json['Password'] != null,
      bio: json['Bio'] ?? "",
      certificate: json['certificate'] ?? "",
      fee: json['fee'] ?? 0,
      rating: json['averageRating'] != null ? json['averageRating'].toDouble(): 0.0,
      verified: json['verified'] ?? false,
      profilePicture: json['profilePicture'],
      payout: json['payout'] != null ? PayoutModel.fromJson(json['payout'] ?? {}) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'FullName': name,
      'Email': email,
      'hasPassword': hasPassword,
      'Role': role,
      'bio': bio,
      'certificate': certificate,
      'fee': fee,
      'rating': rating,
      'verified': verified,
      'payout': payout?.toJson(),
      'profilePicture': profilePicture,
      
    };
  }
    }
    
class PayoutModel extends Equatable {
  final String accountNumber;
  final String accountName;
  final String bankCode;

  const PayoutModel({
    required this.accountNumber,
    required this.accountName,
    required this.bankCode,
  });

  @override
  List<Object?> get props => [bankCode, accountName, accountNumber];


  factory PayoutModel.fromJson(Map<String, dynamic> json) {
    return PayoutModel(
      accountNumber: json['account_number'] ?? '',
      accountName: json['account_name'] ?? '',
      bankCode: json['bank_code'] ?? '',
    );
  }
  
  toJson() {
    return {
      'account_number': accountNumber,
      'account_name': accountName,
      'bank_code': bankCode,
    };
  }
}