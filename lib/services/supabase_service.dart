import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_food_tracker_app/models/food.dart';

class SupabaseService {
  final supabase = Supabase.instance.client;

  // ------ คำสั่ง upload ไฟล์ไปยัง bucket ใน storage
  Future<String> uploadFile(XFile xfile) async {
    final cleanName = xfile.name.replaceAll(' ', '_');
    final newFileName = '${DateTime.now().millisecondsSinceEpoch}_$cleanName';

    await supabase.storage.from('food_tracker_bk').uploadBinary(
          newFileName,
          await xfile.readAsBytes(),
          fileOptions: FileOptions(contentType: xfile.mimeType),
        );

    return supabase.storage.from('food_tracker_bk').getPublicUrl(newFileName);
  }

  // ------ คำสั่ง บันทึกข้อมูลลงใน table ใน DB
  Future<void> insertFood(Food food) async {
    await supabase.from('food_tracker_tb').insert([food.toJson()]);
  }

  // ------ คำสั่ง ดึงข้อมูลจาก table ใน DB
  Future<List<Food>> getAllFoods() async {
    final response = await supabase.from('food_tracker_tb').select('*');
    return response.map((e) => Food.fromJson(e)).toList();
  }

  // ------ คำสั่งลบไฟล์ออกจาก bucket ใน storage
  Future<void> removeFile(String imageUrl) async {
    if (imageUrl.isEmpty) return;

    final rawFileName = imageUrl.split('/').last.split('?').first;
    final fileName = Uri.decodeComponent(rawFileName);

    await supabase.storage.from('food_tracker_bk').remove([fileName]);
  }

  // ------ คำสั่ง บันทึกแก้ไขข้อมูลลงใน table ใน DB
  Future<void> updateFood(Food food, String id) async {
    await supabase.from('food_tracker_tb').update(food.toJson()).eq('id', id);
  }

  // ------ คำสั่ง ลบข้อมูลออกจาก table ใน DB
  Future<void> deleteFood(String id) async {
    await supabase.from('food_tracker_tb').delete().eq('id', id);
  }
}
