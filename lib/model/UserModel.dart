class UserModel {
  int? id;
  String? name;
  String? companyName;
  String? phone;
  String? address;
  String? createdAt;

  UserModel(
      {this.id,
        this.name,
        this.companyName,
        this.phone,
        this.address,
        this.createdAt});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    companyName = json['company_name'];
    phone = json['phone'];
    address = json['address'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['company_name'] = this.companyName;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['created_at'] = this.createdAt;
    return data;
  }
}
