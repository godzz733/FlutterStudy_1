import 'package:archive_idea/data/idea_info.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
class DatabaseHelper {
  late Database _database;

  // 데이터 베이스 초기화 및 열기
  Future<void> initDatabase() async {
    // 데이터 베이스 경로 가져오기
    String path = join(await getDatabasesPath(), 'archive_idea.db');

    // 데이터 베이스 열기 또는 생성
    _database = await openDatabase(path, version: 1, onCreate: (db, version) {
      // 데이터 베이스가 생성될 때 실행되는 코드
      db.execute('''
          CREATE TABLE IF NOT EXISTS tb_idea (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            motive TEXT,
            content TEXT,
            priority INTEGER,
            feedback TEXT,
            createdAt INTEGER
          )
        ''');
    },);
  }

  // IdeaInfo 데이터 추가
  // Sqllite쓸때 데이터를 Map으로 넣어야 되서 일부러 toMap() 이라는 함수를 만들어 준거임
  Future<int> insertIdeaInfo(IdeaInfo idea) async {
    return await _database.insert('tb_idea', idea.toMap());
  }

  // IdeaInfo 데이터 조회
  Future<List<IdeaInfo>> getAllIdeaInfo() async {
    final List<Map<String, dynamic>> result = await _database.query('tb_idea');
    return List.generate(result.length, (index) {
      return IdeaInfo.fromMap(result[index]);
    });
  }

  // IdeaInfo 데이터 업데이트
  Future<int> updateIdeaInfo(IdeaInfo idea) async {
    return await _database.update(
      'tb_idea',
      idea.toMap(),
      where: 'id = ?',
      whereArgs: [idea.id],
    );
  }

  // IdeaInfo 데이터 삭제
  Future<int> deleteIdeaInfo(int id) async {
    return await _database.delete(
      'tb_idea',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // 데이터베이스 닫기
  Future<void> closeDatabase() async {
    await _database.close();
  }
}