import 'package:archive_idea/data/idea_info.dart';
import 'package:archive_idea/database/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var dbHelper = DatabaseHelper();
  List<IdeaInfo> lstIdeaInfo = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getIdeaInfo();
    // setInsertIdeaInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Archive Idea',
          style: TextStyle(
            color: Colors.black,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: lstIdeaInfo.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              child: listItem(index),
              onTap: () async {
                var result = await Navigator.pushNamed(
                  context,
                  '/detail',
                  arguments: lstIdeaInfo[index],
                );

                if (result != null) {
                  String msg = '';

                  if (result == 'update') {
                    msg = '아이디어가 수정 되었습니다';
                  } else if (result == 'delete') {
                    msg = '아이디어가 삭제 되엇습니다';
                  }

                  getIdeaInfo();

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(msg),
                      ),
                    );
                  }

                }
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // 새 아이디어 작성 화면으로 이동
          var result = await Navigator.pushNamed(
              context, '/edit'); // 다른 화면에서 pop시 돌아오는 데이터를 담아옴 (내가 그 화면에서 임의로 넣어서 보낼 수 있음)
          if (result != null) {
            getIdeaInfo();
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('새로운 아이디어가 추가 되었습니다'),
                ),
              );
            }

          }
        },
        child: Image.asset(
          'assets/idea.png',
          width: 48,
          height: 48,
        ),
        backgroundColor: Color(0xff7f52fd).withOpacity(0.7),
      ),
    );
  }

  Widget listItem(int index) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Color(0xffd9d9d9),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10),
      )),
      height: 82,
      // stack 은 컬럼이나 로우같은거랑 다르게 위치를 마음대로 줄 수 있음, 그냥 요소들이 중첩되서 나옴 (각각 다 위치를 조정, absolute 생각하면 됨)
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Container(
            margin: EdgeInsets.only(left: 16, bottom: 16),
            child: Text(
              lstIdeaInfo[index].title,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          // 부모기준 위치를 정할 수 있음
          Align(
            // 부모기준 오른쪽 아래
            alignment: Alignment.bottomRight,
            child: Container(
                margin: EdgeInsets.only(right: 16, bottom: 8),
                child: Text(
                  DateFormat("yyyy.MM.dd HH:mm").format(
                      DateTime.fromMillisecondsSinceEpoch(
                          lstIdeaInfo[index].createdAt)),
                  style: TextStyle(
                    color: Color(0xffaeaeae),
                    fontSize: 10,
                  ),
                )),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              margin: EdgeInsets.only(left: 16, bottom: 8),
              child: RatingBar.builder(
                initialRating: lstIdeaInfo[index].priority.toDouble(),
                minRating: 1,
                direction: Axis.horizontal,
                itemSize: 16,
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
            ),
          )
        ],
      ),
    );
  }

  Future getIdeaInfo() async {
    await dbHelper.initDatabase();
    lstIdeaInfo = await dbHelper.getAllIdeaInfo();
    lstIdeaInfo.sort(
      (a, b) => b.createdAt.compareTo(b.createdAt),
    );
    // setState를 하면 데이터 전반적으로 업데이트를 함
    setState(() {});
  }

  Future setInsertIdeaInfo() async {
    await dbHelper.initDatabase();
    await dbHelper.insertIdeaInfo(IdeaInfo(
        title: '#환경 보존',
        motive: '쓰레기버리기',
        content: '쓰레기',
        priority: 5,
        feedback: '피드백 하세요',
        createdAt: DateTime.now().millisecondsSinceEpoch));
  }
}
