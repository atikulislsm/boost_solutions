import 'dart:convert';
import 'package:get/get.dart';

class DollarRequest {
  final int id;
  final String boostAgencyId;
  final String boostAgencyResellerId;
  final String boostAgencyResellerAdAccountId;
  final String? balanceId;
  final String dollar;
  final String rate;
  final String supplierRate;
  final String amount;
  final String status;
  final String? image;
  final String createdAt;
  final String updatedAt;
  final Account? account;
  final Balance? balance;

  DollarRequest({
    required this.id,
    required this.boostAgencyId,
    required this.boostAgencyResellerId,
    required this.boostAgencyResellerAdAccountId,
    this.balanceId,
    required this.dollar,
    required this.rate,
    required this.supplierRate,
    required this.amount,
    required this.status,
    this.image,
    required this.createdAt,
    required this.updatedAt,
    this.account,
    this.balance,
  });

  factory DollarRequest.fromJson(Map<String, dynamic> json) {
    return DollarRequest(
      id: json['id'],
      boostAgencyId: json['boost_agency_id'],
      boostAgencyResellerId: json['boost_agency_reseller_id'],
      boostAgencyResellerAdAccountId: json['boost_agency_reseller_ad_account_id'],
      balanceId: json['balance_id'],
      dollar: json['dollar'],
      rate: json['rate'],
      supplierRate: json['supplier_rate'],
      amount: json['amount'],
      status: json['status'],
      image: json['image'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      account: json['account'] != null ? Account.fromJson(json['account']) : null,
      balance: json['balance'] != null ? Balance.fromJson(json['balance']) : null,
    );
  }
}

class Account {
  final int id;
  final String name;

  Account({required this.id, required this.name});

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'],
      name: json['name'],
    );
  }
}

class Balance {
  final int id;
  final String name;

  Balance({required this.id, required this.name});

  factory Balance.fromJson(Map<String, dynamic> json) {
    return Balance(
      id: json['id'],
      name: json['name'],
    );
  }
}