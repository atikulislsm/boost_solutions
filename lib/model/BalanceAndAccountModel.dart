class BalanceAndAccountModel {
  bool? status;
  Data? data;

  BalanceAndAccountModel({this.status, this.data});

  BalanceAndAccountModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<Balances>? balances;
  List<AddAccounts>? addAccounts;

  Data({this.balances, this.addAccounts});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['balances'] != null) {
      balances = <Balances>[];
      json['balances'].forEach((v) {
        balances!.add(new Balances.fromJson(v));
      });
    }
    if (json['add_accounts'] != null) {
      addAccounts = <AddAccounts>[];
      json['add_accounts'].forEach((v) {
        addAccounts!.add(new AddAccounts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.balances != null) {
      data['balances'] = this.balances!.map((v) => v.toJson()).toList();
    }
    if (this.addAccounts != null) {
      data['add_accounts'] = this.addAccounts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Balances {
  String? id;
  String? name;
  String? amount;
  String? status;


  Balances(
      {this.id,
        this.name,
        this.amount,
        this.status,
});

  Balances.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'];
    amount = json['amount'].toString();
    status = json['status'].toString();

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['amount'] = this.amount;
    data['status'] = this.status;

    return data;
  }
}

class AddAccounts {
  String? id;
  String? boostAgencyId;
  String? boostAgencyResellerId;
  String? name;
  String? pageName;
  String? dollarRate;
  String? totalDollar;
  String? totalAmount;


  AddAccounts(
      {this.id,
        this.boostAgencyId,
        this.boostAgencyResellerId,
        this.name,
        this.pageName,
        this.dollarRate,
        this.totalDollar,
        this.totalAmount,
      });

  AddAccounts.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    boostAgencyId = json['boost_agency_id'].toString();
    boostAgencyResellerId = json['boost_agency_reseller_id'].toString();
    name = json['name'].toString();
    pageName = json['page_name'].toString();
    dollarRate = json['dollar_rate'].toString();
    totalDollar = json['total_dollar'].toString();
    totalAmount = json['total_amount'].toString();

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['boost_agency_id'] = this.boostAgencyId;
    data['boost_agency_reseller_id'] = this.boostAgencyResellerId;
    data['name'] = this.name;
    data['page_name'] = this.pageName;
    data['dollar_rate'] = this.dollarRate;
    data['total_dollar'] = this.totalDollar;
    data['total_amount'] = this.totalAmount;

    return data;
  }
}
