import 'package:archive_idea/data/idea_info.dart';
import 'package:archive_idea/database/database_helper.dart';
import 'package:flutter/material.dart';

class EditScreen extends StatefulWidget {
  IdeaInfo? ideaInfo;

  EditScreen({super.key, this.ideaInfo});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _motiveController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _feedbackController = TextEditingController();

  var dbHelper = DatabaseHelper();

  // 아이디어 중요도 점수
  int ideaStar = 3;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // 기존 데이터 수정 시 데이터 미리 써놓기
    if (widget.ideaInfo != null) {
      _titleController.text = widget.ideaInfo!.title;
      _motiveController.text = widget.ideaInfo!.motive;
      _contentController.text = widget.ideaInfo!.content;
      _feedbackController.text = widget.ideaInfo!.feedback;
      ideaStar = widget.ideaInfo!.priority;
    }
  }

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
          widget.ideaInfo == null? '새 아이디어 작성' : '아이디어 편집',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('제목'),
              Container(
                height: 41,
                margin: EdgeInsets.only(top: 8),
                child: TextField(
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffd9d9d9)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: '아이디어 제목',
                      hintStyle: TextStyle(
                        color: Color(0xffb4b4b4),
                      )),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                  ),
                  controller: _titleController,
                ),
              ),
              SizedBox(
                height: 16,
              ), // 위 아래 간격을 위한 박스임
              Text('아이디어를 떠올린 계기'),
              Container(
                height: 41,
                margin: EdgeInsets.only(top: 8),
                child: TextField(
                  textInputAction: TextInputAction.next, // 입력버튼 누르면 다음 입력창으로 이동
                  decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffd9d9d9)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: '아이디어를 떠올리게 된 계기',
                      hintStyle: TextStyle(
                        color: Color(0xffb4b4b4),
                      )),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                  ),
                  controller: _motiveController,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Text('아이디어 내용'),
              Container(
                margin: EdgeInsets.only(top: 8),
                child: TextField(
                  maxLines: 5,
                  maxLength: 500,
                  decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffd9d9d9)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: '떠오르신 아이디어를 자세하게 작성해 주세요',
                      hintStyle: TextStyle(
                        color: Color(0xffb4b4b4),
                      )),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                  ),
                  controller: _contentController,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Text('아이디어 중요도 점수'),
              Container(
                margin: EdgeInsets.only(top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    for (int i = 1; i <= 5; i++)
                      GestureDetector(
                        child: Container(
                          alignment: Alignment.center,
                          decoration: ShapeDecoration(
                              color: ideaStar == i
                                  ? Color(0xffd6d6d6)
                                  : Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 1, color: Colors.black),
                                borderRadius: BorderRadius.circular(10),
                              )),
                          width: 50,
                          height: 40,
                          child: Text(
                            i.toString(),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            ideaStar = i;
                          });
                        },
                      ),
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Text('유저 피드백 사항 (선택)'),
              Container(
                margin: EdgeInsets.only(top: 8),
                child: TextField(
                  maxLength: 500,
                  maxLines: 5,
                  decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffd9d9d9)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: '떠오르신 아이디어 기반으로\n전달받은 피드백들을 정리해주세요',
                      hintStyle: TextStyle(
                        color: Color(0xffb4b4b4),
                      )),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                  ),
                  controller: _feedbackController,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              GestureDetector(
                child: Container(
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
                    widget.ideaInfo != null ? '아이디어 수정 완료' : '아이디어 작성 완료',
                  ),
                ),
                onTap: () {
                  // 클릭하면 DB에 저장
                  if (widget.ideaInfo != null) {
                    setUpdateInfo();
                  } else {
                    setSaveInfo();
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Future setSaveInfo() async {
    String titleValue = _titleController.text.toString();
    String motiveValue = _titleController.text.toString();
    String contentValue = _titleController.text.toString();
    String feedbackValue = _titleController.text.toString();
    if (titleValue.isEmpty || motiveValue.isEmpty || contentValue.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('비어있는 값이 존재합니다'),
        duration: Duration(seconds: 2),
      ));
      return;
    }

    if (widget.ideaInfo == null) {
      var ideaInfo = IdeaInfo(
        title: titleValue,
        motive: motiveValue,
        content: contentValue,
        priority: ideaStar,
        feedback: feedbackValue.isNotEmpty ? feedbackValue : '',
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );

      await dbHelper.initDatabase();
      await dbHelper.insertIdeaInfo(ideaInfo);
      if (mounted) {
        Navigator.pop(context, 'insert');
      }

    }
  }

  Future setUpdateInfo() async {
    String titleValue = _titleController.text.toString();
    String motiveValue = _titleController.text.toString();
    String contentValue = _titleController.text.toString();
    String feedbackValue = _titleController.text.toString();
    if (titleValue.isEmpty || motiveValue.isEmpty || contentValue.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('비어있는 값이 존재합니다'),
        duration: Duration(seconds: 2),
      ));
      return;
    }

    var ideaInfoModify = widget.ideaInfo;
    ideaInfoModify?.title = titleValue;
    ideaInfoModify?.motive = motiveValue;
    ideaInfoModify?.content = contentValue;
    ideaInfoModify?.priority = ideaStar;
    ideaInfoModify?.feedback = feedbackValue.isNotEmpty ? feedbackValue : '';

    await dbHelper.initDatabase();
    await dbHelper.updateIdeaInfo(ideaInfoModify!);
    if (mounted) {
      Navigator.pop(context, 'update');
    }
  }
}
