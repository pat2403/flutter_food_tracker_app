// ignore_for_file: prefer_final_fields

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_food_tracker_app/models/food.dart';
import 'package:flutter_food_tracker_app/services/supabase_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class UpdateDeleteFoodTrackerUI extends StatefulWidget {
  // สร้างตัวแปรมารับข้อมูลที่ส่งมา เพื่อเอาไปใช้กับคลาสด้านล่าง
  Food? foodUDShow;

  // เอาตัวแปรที่สร้างมารับข้อมูล
  UpdateDeleteFoodTrackerUI({super.key, this.foodUDShow});

  @override
  State<UpdateDeleteFoodTrackerUI> createState() =>
      _UpdateDeleteFoodTrackerUIState();
}

class _UpdateDeleteFoodTrackerUIState extends State<UpdateDeleteFoodTrackerUI> {
  // ------ โค้ดคำสั่งที่เกี่ยวกับการเปิดกล้อง หรือแกลลอรี่ -------
  Uint8List? imageBytes; // เอาไว้เก็บรูปที่จะแสดงที่ UI บนหน้าจอ
  XFile? imageFile; // เอาไว้เก็บรูปที่จะเป็นไฟล์

  Future<void> openGalleryAndTakePhoto() async {
    // เปิดกล้องเพื่อถ่ายรูป
    imageFile = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 80);

    // แปลงรูปที่ถ่ายเป็น Byte เพื่อแสดงที่ UI บนหน้าจอ แต่ต้องตรวจสอบก่อนว่าเขาได้ถ่ายไหม
    if (imageFile != null) {
      final bytes = await imageFile!.readAsBytes();
      setState(() {
        imageBytes = bytes;
      });
    }
  }

  // เมธอดเปิด gallery เพื่อเลือกรูปภาพ
  Future<void> openGalleryAndSelectPhoto() async {
    // เปิด gallery เพื่อเลือกรูปภาพ
    imageFile = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 80);

    // แปลงรูปที่ถ่ายเป็น Byte เพื่อแสดงที่ UI บนหน้าจอ แต่ต้องตรวจสอบก่อนว่าเขาได้เลือกรูปไหม
    if (imageFile != null) {
      final bytes = await imageFile!.readAsBytes();
      setState(() {
        imageBytes = bytes;
      });
    }
  }

  // ตัวแปรเก็บมื้อที่เลือก
  String selectedMeal = 'เช้า'; // ค่าเริ่มต้นเป็น 'เช้า'

  List<String> meals = ['เช้า', 'กลางวัน', 'เย็น', 'ว่าง']; // รายการมื้ออาหาร

  // ประกาศตัวแปรสำหรับ TextEditingController เพื่อจัดการกับ TextField
  TextEditingController _dateController = TextEditingController();
  TextEditingController foodNameCtrl = TextEditingController();
  TextEditingController foodPriceCtrl = TextEditingController();
  TextEditingController foodPersonCtrl = TextEditingController();

  // ตัวแปรเก็บที่อยู๋รูปกรณีมีการอัปโหลดไฟล์
  String imageUrlFromUpload = '';

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        // แปลงวันที่เป็นรูปแบบ "วัน/เดือน/ปี"
        _dateController.text =
            "${pickedDate.year}/${pickedDate.month}/${pickedDate.day}";
      });
    }
  }

  @override
  void initState() {
    // เอาข้อมูลที่ส่งมากำหนดให้กับ widget บนหน้าจอ
    _dateController.text = widget.foodUDShow!.foodDate.toString();
    foodNameCtrl.text = widget.foodUDShow!.foodName.toString();
    foodPriceCtrl.text = widget.foodUDShow!.foodPrice.toString();
    foodPersonCtrl.text = widget.foodUDShow!.foodPerson.toString();
    selectedMeal = widget.foodUDShow!.foodMeal.toString();
    imageUrlFromUpload = widget.foodUDShow!.foodImageUrl ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ส่วน AppBar
      appBar: AppBar(
        title: Text(
          'Food Tracker (แก้ไข/ลบ)',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 246, 65, 9),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

      // ส่วน body
      body: Padding(
        padding: const EdgeInsets.only(
          top: 25,
          left: 25,
          right: 25,
          bottom: 25,
        ),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.07,
                ),
                // ------------------------------------------------------------
                // ใช้ Ternary Operator แบบต่อเนื่อง
                imageFile !=
                        null // ได้ถ่าย-เลือกรูปหรือไม่ ถ้าถ่าย-เลือกก็แสดงรูปที่ถ่าย-เลือก
                    ? InkWell(
                        onTap: () {
                          openGalleryAndTakePhoto();
                        },
                        child: Image.memory(
                          imageBytes!,
                          width: MediaQuery.of(context).size.width * 0.35,
                          height: MediaQuery.of(context).size.width * 0.35,
                        ),
                      )
                    : widget.foodUDShow!.foodImageUrl != ""
                        ? InkWell(
                            onTap: () {
                              openGalleryAndTakePhoto();
                            },
                            child: Image.network(
                              widget.foodUDShow!.foodImageUrl.toString(),
                              width: MediaQuery.of(context).size.width * 0.35,
                              height: MediaQuery.of(context).size.width * 0.35,
                            ),
                          )
                        : InkWell(
                            onTap: () {
                              openGalleryAndTakePhoto();
                            },
                            child: Image.asset(
                              'assets/images/burger.png',
                              width: MediaQuery.of(context).size.width * 0.35,
                              height: MediaQuery.of(context).size.width * 0.35,
                            ),
                          ),
                // ------------------------------------------------------------
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.07,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'กินอะไร',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.045,
                    ),
                  ),
                ),
                TextField(
                  controller: foodNameCtrl,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'กินมื้อไหน',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.045,
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.005,
                ),
                // เลือกมื้ออาหารแบบปุ่มกด 4 มื้ออาหาร (เช้า, กลางวัน, เย็น, ว่าง)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    spacing: 10,
                    children: meals.map((meal) {
                      // เช็คว่าปุ่มนี้เป็นปุ่มที่ถูกเลือกหรือไม่
                      bool isSelected = selectedMeal == meal;

                      return ElevatedButton(
                        onPressed: () {
                          // เมื่อกดปุ่ม ให้เปลี่ยนค่า selectedMeal เป็นมื้อที่ถูกเลือก
                          setState(() {
                            selectedMeal = meal;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          // เปลี่ยนสีปุ่มตามสถานะการเลือก
                          backgroundColor: isSelected
                              ? Colors.green // สีปุ่มเมื่อถูกเลือก
                              : Colors.grey[400], // สีปุ่มเมื่อไม่ถูกเลือก
                          elevation:
                              isSelected ? 2 : 0, // เพิ่มเงาเมื่อถูกเลือก
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          meal,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : Colors
                                    .white, // เปลี่ยนสีข้อความตามสถานะการเลือก
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.025,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'กินไปเท่าไหร่',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.045,
                    ),
                  ),
                ),
                TextField(
                  controller: foodPriceCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.025,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'กินกันกี่คน',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.045,
                    ),
                  ),
                ),
                TextField(
                  controller: foodPersonCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.025,
                ),
                // ส่วนเลือกวันที่
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'กินไปวันไหน',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.045,
                    ),
                  ),
                ),
                TextField(
                  controller: _dateController,
                  readOnly: true, // ทำให้ TextField ไม่สามารถแก้ไขได้โดยตรง
                  onTap: () => _selectDate(
                      context), // เมื่อกด TextField ให้เรียกฟังก์ชันเลือกวันที่
                  decoration: InputDecoration(
                    hintText: 'เช่น 2020-01-31',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () => _selectDate(
                          context), // เมื่อกดไอคอนให้เรียกฟังก์ชันเลือกวันที่
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.025,
                ),
                // ส่วนปุ่มบันทึก
                ElevatedButton(
                  onPressed: () async {
                    if (foodNameCtrl.text.isEmpty ||
                        foodPriceCtrl.text.isEmpty ||
                        foodPersonCtrl.text.isEmpty ||
                        _dateController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('กรุณากรอกข้อมูลให้ครบ'),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 3),
                        ),
                      );
                      return;
                    }

                    if (imageFile != null) {
                      // ลบรูปเดิม (ถ้ามี)
                      final oldImageUrl = widget.foodUDShow!.foodImageUrl ?? '';
                      if (oldImageUrl.isNotEmpty) {
                        await SupabaseService().removeFile(oldImageUrl);
                      }
                      // อัปโหลดรูปใหม่
                      imageUrlFromUpload =
                          await SupabaseService().uploadFile(imageFile!);
                    }

                    Food food = Food(
                      foodName: foodNameCtrl.text,
                      foodMeal: selectedMeal,
                      foodPrice: double.parse(foodPriceCtrl.text),
                      foodPerson: int.parse(foodPersonCtrl.text),
                      foodDate: _dateController.text,
                      foodImageUrl: imageUrlFromUpload,
                    );

                    await SupabaseService()
                        .updateFood(food, widget.foodUDShow!.id!);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('บันทึกแก้ไขข้อมูลเรียบร้อย'),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 3),
                      ),
                    );
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: Size(
                      MediaQuery.of(context).size.width * 0.9,
                      MediaQuery.of(context).size.height * 0.07,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Text(
                    'บันทึกแก้ไข',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.width * 0.045,
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.015,
                ),
                // ส่วนปุ่มยกเลิก
                ElevatedButton(
                  onPressed: () async {
                    // ตรวจสอบก่อนว่าข้อมูลที่ลบมีรูปเดิมไหม ถ้ามีอย่าลืมลบรูปทิ้งด้วย
                    final imageUrl = widget.foodUDShow!.foodImageUrl ?? '';
                    if (imageUrl.isNotEmpty) {
                      await SupabaseService().removeFile(imageUrl);
                    }
                    // ลบข้อมูลออกจาก DB
                    await SupabaseService().deleteFood(widget.foodUDShow!.id!);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('ลบข้อมูลเรียบร้อย'),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 3),
                      ),
                    );
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: Size(
                      MediaQuery.of(context).size.width * 0.9,
                      MediaQuery.of(context).size.height * 0.07,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Text(
                    'ลบข้อมูล',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.width * 0.045,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
