// ไฟล์ประเภทโมเดล จะใช้สำหรับแมปข้อมูลต่าง ๆ ที่จะทำงานด้วยซึ่งจะล้อกับ colum ใน table ใน DB
// รวมถึงคำสั่งแปลง JSON เป็น Object(ข้อมูลใช้ในโปรเจค) และ Object(ข้อมูลใช้ในโปรเจค) เป็น JSON ด้วย
// ignore_for_file: non_constant_identifier_names

class Food {
  // ตัวแปรที่ล้อกับ column ใน table ใน DB
  String? id;
  String? created_at;
  String? foodDate;
  String? foodMeal;
  String? foodName;
  double? foodPrice;
  int? foodPerson;
  String? foodImageUrl;

  // Constructor (เอาไว้แพ็คข้อมูล)
  Food({
    this.id,
    this.created_at,
    this.foodDate,
    this.foodMeal,
    this.foodName,
    this.foodPrice,
    this.foodPerson,
    this.foodImageUrl,
  });

  // คำสั่งแปลง JSON เป็น Object(ข้อมูลใช้ในโปรเจค) เรียกว่า fromJson
  factory Food.fromJson(Map<String, dynamic> json) => Food(
        id: json['id'] as String?,
        created_at: json['created_at'] as String?,
        foodDate: json['foodDate'] as String?,
        foodMeal: json['foodMeal'] as String?,
        foodName: json['foodName'] as String?,
        foodPrice: (json['foodPrice'] as num?)?.toDouble(),
        foodPerson: json['foodPerson'] as int?,
        foodImageUrl: json['foodImageUrl'] as String?,
      );
  // คำสั่งแปลง Object(ข้อมูลใช้ในโปรเจค) เป็น JSON เรียกว่า toJson
  Map<String, dynamic> toJson() => {
        'foodDate': foodDate,
        'foodMeal': foodMeal,
        'foodName': foodName,
        'foodPrice': foodPrice,
        'foodPerson': foodPerson,
        'foodImageUrl': foodImageUrl,
      };
}
