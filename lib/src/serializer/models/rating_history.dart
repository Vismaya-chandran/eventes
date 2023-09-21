class EmployeeRatingHistory {
  final int? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? rating;
  final String? category;
  final String? due;
  final String? payment;
  final String? status;
  final int? user;
  final int? employee;
  final dynamic venue;

  EmployeeRatingHistory({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.rating,
    this.category,
    this.due,
    this.payment,
    this.status,
    this.user,
    this.employee,
    this.venue,
  });

  factory EmployeeRatingHistory.fromJson(Map<String, dynamic> json) =>
      EmployeeRatingHistory(
        id: json["id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        rating: json["rating"],
        category: json["category"],
        due: json["due"],
        payment: json["payment"],
        status: json["status"],
        user: json["user"],
        employee: json["employee"],
        venue: json["venue"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "rating": rating,
        "category": category,
        "due": due,
        "payment": payment,
        "status": status,
        "user": user,
        "employee": employee,
        "venue": venue,
      };
}
