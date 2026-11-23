// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter_food_tracker_app/models/food.dart';
import 'package:flutter_food_tracker_app/services/supabase_service.dart';
import 'package:flutter_food_tracker_app/views/add_food_tracker_ui.dart';
import 'package:flutter_food_tracker_app/views/update_delete_food_tracker_ui.dart';

class ShowAllFoodTrackerUI extends StatefulWidget {
  const ShowAllFoodTrackerUI({super.key});

  @override
  State<ShowAllFoodTrackerUI> createState() => _ShowAllFoodTrackerUIState();
}

class _ShowAllFoodTrackerUIState extends State<ShowAllFoodTrackerUI> {
  // สร้างตัวแปรเก็บข้อมูลที่ดึงมาจาก Supabase
  List<Food>? foodData;

  // สร้างคำสั่งเรียกใช้เมธอดดึงข้อมูลจาก SupabaseService()
  Future<void> fetchFoodData() async {
    final data = await SupabaseService().getAllFoods();
    setState(() {
      foodData = data;
    }); // ใช้ setState เพื่อให้ UI อัปเดตตามข้อมูลใหม่
  }

  @override
  void initState() {
    fetchFoodData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ส่วน AppBar
      appBar: AppBar(
        title: Text(
          'Food Tracker',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 246, 65, 9),
        centerTitle: true,
      ),
      // ส่วน floatingActionButton
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddFoodTrackerUI(),
            ),
          );
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Color.fromARGB(255, 246, 65, 9), // สีปุ่ม
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // ปรับความโค้งของปุ่ม
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      // ส่วน body
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Image.asset(
                'assets/images/burger.png',
                width: MediaQuery.of(context).size.width * 0.4,
                height: MediaQuery.of(context).size.height * 0.25,
              ),
              Expanded(
                child: ListView.separated(
                    itemCount: foodData?.length ?? 0,
                    separatorBuilder: (context, index) => Divider(),
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () async {
                          // เปิดไปหน้า UpdateDeleteFoodTrackerUI แบบย้อนกลับได้
                          // และตอนย้อนกลับมาอย่าลืมไปดึงข้อมูลมาใหม่
                          // เปิดไปแล้วอย่าลืมส่งข้อมูลของรายการนั้นไปด้วย
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdateDeleteFoodTrackerUI(
                                foodUDShow: foodData![index],
                              ),
                            ),
                          );

                          // เมื่อย้อนกลับมาแล้วไปดึงข้อมูลมาใหม่
                          fetchFoodData();
                        },
                        title: Text(
                          'กิน: ${foodData?[index].foodName}',
                        ),
                        subtitle: Text(
                          'วันที่: ${foodData?[index].foodDate}' +
                              '  มื้อ: ${foodData?[index].foodMeal}',
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Color.fromARGB(255, 246, 65, 9),
                        ),
                        leading: foodData![index].foodImageUrl == ''
                            ? Image.asset(
                                'assets/images/burger.png',
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                foodData![index].foodImageUrl!,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
