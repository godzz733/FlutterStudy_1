import 'package:archive_idea/data/idea_info.dart';
import 'package:archive_idea/database/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class DetailScreen extends StatelessWidget {
  IdeaInfo? ideaInfo;
  final dbhelper = DatabaseHelper();

  DetailScreen({super.key, this.ideaInfo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          child: Icon(
            Icons.arrow_back_ios_new,
            size: 24,
            color: Colors.black,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          ideaInfo!.title,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('주의'),
                      content: Text('아이디어를 정말 삭제하시겠습니까?'),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              '취소',
                              style: TextStyle(color: Colors.grey),
                            )),
                        TextButton(
                            onPressed: () async {
                              await setDeleteIdeaInfo(ideaInfo!.id!);
                              if (context.mounted) {
                                Navigator.of(context).pop();
                                Navigator.pop(context,'delete');
                              }
                            },
                            child: Text(
                              '삭제',
                              style: TextStyle(color: Colors.grey),
                            )),
                      ],
                    );
                  },
                );
              },
              child: Text(
                '삭제',
                style: TextStyle(color: Colors.red, fontSize: 16),
              )),
        ], // 우측 영역
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex:1, child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '아이디어를 떠올린 계기',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(ideaInfo!.motive, style: TextStyle(color: Color(0xffa5a5a5)),),
                  SizedBox(height: 30,),

                  Text(
                    '아이디어 내용',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(ideaInfo!.content, style: TextStyle(color: Color(0xffa5a5a5)),),
                  SizedBox(height: 30,),

                  Text(
                    '아이디어 중요도 점수',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  RatingBar.builder(
                    initialRating: ideaInfo!.priority.toDouble(),
                    minRating: 1,
                    direction: Axis.horizontal,
                    itemSize: 35,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 0),
                    itemBuilder: (context, index) {
                      return Icon(
                        Icons.star,
                        color: Colors.amber,
                      );
                    },
                    ignoreGestures: true,
                    updateOnDrag: false,
                    onRatingUpdate: (value) {},
                  ),
                  SizedBox(height: 30,),

                  Text(
                    '유저 피드백 사항',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(ideaInfo!.feedback, style: TextStyle(color: Color(0xffa5a5a5)),),
                  SizedBox(height: 30,),


                ],
              ),
            ),
          ),),
          GestureDetector(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 16,horizontal: 16),
              height: 65,
              alignment: Alignment.center,
              decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1,
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  )),
              child: Text(
                '아이디어 수정 하기',
              ),
            ),
            onTap: () async {
              var result = await Navigator.pushNamed(context, '/edit',arguments: ideaInfo);
              if (result != null) {
                if (context.mounted) {
                  Navigator.pop(context, 'update');
                }
              }
            },
          )
        ],
      ),
    );
  }

  Future setDeleteIdeaInfo(int id) async {
    await dbhelper.initDatabase();
    await dbhelper.deleteIdeaInfo(id);
  }
}
