class EmployeeTypeIdResponse {
  final int? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? name;
  final String? code;
  final String? amount;

  EmployeeTypeIdResponse({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.name,
    this.code,
    this.amount,
  });

  factory EmployeeTypeIdResponse.fromJson(Map<String, dynamic> json) =>
      EmployeeTypeIdResponse(
        id: json["id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        name: json["name"],
        code: json["code"],
        amount: json["amount"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "name": name,
        "code": code,
        "amount": amount,
      };
}
