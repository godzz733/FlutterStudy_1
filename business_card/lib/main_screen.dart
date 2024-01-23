import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  TextEditingController introduceController = TextEditingController();
  bool isEditMode = false;
  List<String> category = ['이름','나이','취미','직업','학력','MBTI'];
  List<String> information = ['홍길동','25','게임','학생','서울대학교','EJRW'];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // 위젯이 처음 실행되었을때 실행되는 곳
    getIntroduceData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: Icon(
            Icons.accessibility_new,
            color: Colors.black,
            size: 32,
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            "발전하는 개발자 홍드로이드를 소개합니다",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black),
          )),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 200,
              margin: EdgeInsets.all(16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/image.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            for (int i=0; i<6; i++)
              Container(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Row(
                  children: [
                    Container(
                        width: 150,
                        child: Text(
                          category[i],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    Text(
                      information[i],
                    ),
                  ],
                ),
              ),
            // 자기소개 입력 필드
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 16, top: 16),
                  child: Text(
                    '자기소개',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                GestureDetector(onTap:() async {
                  if (isEditMode) {
                    if (introduceController.text.isEmpty) {
                      var snackBar = SnackBar(content: Text('자기소개 입력값이 비어있습니다'),
                        duration: Duration(seconds: 2),);
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      return;
                    }
                    var sharedPref = await SharedPreferences.getInstance();
                    sharedPref.setString('introduce', introduceController.text);
                  }
                  setState(() {
                    isEditMode = !isEditMode;
                  });
                },child: Container(
                  margin: EdgeInsets.only(right: 16, top: 16),
                  child: Icon(
                    Icons.mode_edit,
                    color: isEditMode ? Colors.blueAccent : Colors.black,
                    size: 24,
                  ),
                ),)

              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: TextField(
                enabled: isEditMode,
                maxLines: 5,
                controller: introduceController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Color(0xffd9d9d9)),
                )),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> getIntroduceData() async {
    var sharedPref = await SharedPreferences.getInstance();
    String introduceMsg = sharedPref.getString('introduce').toString();
    introduceController.text = introduceMsg ?? "";
  }
}
