import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/location_point.dart';
import '../models/track_session.dart';
import '../models/score_summary.dart';
import '../models/medal.dart';

class DatabaseService {
  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'move_tracker.db');

    return openDatabase(
      path,
      version: 3,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE track_sessions (
        id TEXT PRIMARY KEY,
        start_time INTEGER NOT NULL,
        end_time INTEGER,
        status INTEGER NOT NULL,
        total_distance REAL DEFAULT 0,
        duration_seconds INTEGER DEFAULT 0,
        walking_seconds INTEGER DEFAULT 0,
        cycling_seconds INTEGER DEFAULT 0,
        vehicle_seconds INTEGER DEFAULT 0,
        total_score REAL DEFAULT 0,
        dot_count INTEGER DEFAULT 0,
        dot_score INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE location_points (
        id TEXT PRIMARY KEY,
        session_id TEXT NOT NULL,
        timestamp INTEGER NOT NULL,
        latitude REAL NOT NULL,
        longitude REAL NOT NULL,
        accuracy REAL NOT NULL,
        speed REAL,
        speed_kmh REAL,
        mode INTEGER NOT NULL,
        FOREIGN KEY (session_id) REFERENCES track_sessions (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE score_summary (
        id INTEGER PRIMARY KEY CHECK (id = 1),
        total_score REAL DEFAULT 0,
        walking_score REAL DEFAULT 0,
        walking_seconds INTEGER DEFAULT 0,
        cycling_score REAL DEFAULT 0,
        cycling_seconds INTEGER DEFAULT 0,
        vehicle_score REAL DEFAULT 0,
        vehicle_seconds INTEGER DEFAULT 0,
        total_dot_count INTEGER DEFAULT 0,
        total_dot_score INTEGER DEFAULT 0,
        last_updated INTEGER NOT NULL
      )
    ''');

    // 初期スコアデータを挿入
    await db.insert('score_summary', {
      'id': 1,
      'total_score': 0,
      'walking_score': 0,
      'walking_seconds': 0,
      'cycling_score': 0,
      'cycling_seconds': 0,
      'vehicle_score': 0,
      'vehicle_seconds': 0,
      'total_dot_count': 0,
      'total_dot_score': 0,
      'last_updated': DateTime.now().millisecondsSinceEpoch,
    });

    // メダルテーブル
    await _createMedalTable(db);
  }

  Future<void> _createMedalTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS user_medals (
        id TEXT PRIMARY KEY,
        medal_type INTEGER NOT NULL UNIQUE,
        earned_at INTEGER NOT NULL
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await _createMedalTable(db);
    }
    if (oldVersion < 3) {
      // ドットカラム追加
      await db.execute('ALTER TABLE track_sessions ADD COLUMN dot_count INTEGER DEFAULT 0');
      await db.execute('ALTER TABLE track_sessions ADD COLUMN dot_score INTEGER DEFAULT 0');
      await db.execute('ALTER TABLE score_summary ADD COLUMN total_dot_count INTEGER DEFAULT 0');
      await db.execute('ALTER TABLE score_summary ADD COLUMN total_dot_score INTEGER DEFAULT 0');
    }
  }

  // Track Sessions
  Future<void> insertSession(TrackSession session) async {
    final db = await database;
    await db.insert('track_sessions', session.toMap());
  }

  Future<void> updateSession(TrackSession session) async {
    final db = await database;
    await db.update(
      'track_sessions',
      session.toMap(),
      where: 'id = ?',
      whereArgs: [session.id],
    );
  }

  Future<TrackSession?> getSession(String id) async {
    final db = await database;
    final maps = await db.query(
      'track_sessions',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return TrackSession.fromMap(maps.first);
  }

  Future<List<TrackSession>> getAllSessions() async {
    final db = await database;
    final maps = await db.query(
      'track_sessions',
      orderBy: 'start_time DESC',
    );
    return maps.map((m) => TrackSession.fromMap(m)).toList();
  }

  Future<TrackSession?> getActiveSession() async {
    final db = await database;
    final maps = await db.query(
      'track_sessions',
      where: 'status = ?',
      whereArgs: [TrackStatus.active.index],
    );
    if (maps.isEmpty) return null;
    return TrackSession.fromMap(maps.first);
  }

  // Location Points
  Future<void> insertLocationPoint(LocationPoint point) async {
    final db = await database;
    await db.insert('location_points', point.toMap());
  }

  Future<List<LocationPoint>> getPointsForSession(String sessionId) async {
    final db = await database;
    final maps = await db.query(
      'location_points',
      where: 'session_id = ?',
      whereArgs: [sessionId],
      orderBy: 'timestamp ASC',
    );
    return maps.map((m) => LocationPoint.fromMap(m)).toList();
  }

  // Score Summary
  Future<ScoreSummary> getScoreSummary() async {
    final db = await database;
    final maps = await db.query('score_summary', where: 'id = 1');
    if (maps.isEmpty) return ScoreSummary.empty();
    return ScoreSummary.fromMap(maps.first);
  }

  Future<void> updateScoreSummary(ScoreSummary summary) async {
    final db = await database;
    await db.update(
      'score_summary',
      {...summary.toMap(), 'id': 1},
      where: 'id = 1',
    );
  }

  // User Medals
  Future<void> insertMedal(UserMedal medal) async {
    final db = await database;
    await db.insert(
      'user_medals',
      medal.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<List<UserMedal>> getAllMedals() async {
    final db = await database;
    final maps = await db.query(
      'user_medals',
      orderBy: 'earned_at DESC',
    );
    return maps.map((m) => UserMedal.fromMap(m)).toList();
  }

  Future<bool> hasMedal(MedalType type) async {
    final db = await database;
    final maps = await db.query(
      'user_medals',
      where: 'medal_type = ?',
      whereArgs: [type.index],
    );
    return maps.isNotEmpty;
  }

  Future<Set<MedalType>> getEarnedMedalTypes() async {
    final db = await database;
    final maps = await db.query('user_medals');
    return maps.map((m) => MedalType.values[m['medal_type'] as int]).toSet();
  }

  // 累計距離を計算（完了したセッションの合計）
  Future<double> getTotalDistance() async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT SUM(total_distance) as total
      FROM track_sessions
      WHERE status = ?
    ''', [TrackStatus.completed.index]);
    return (result.first['total'] as num?)?.toDouble() ?? 0;
  }

  // 連続記録日数を計算
  Future<int> getCurrentStreak() async {
    final db = await database;
    final sessions = await db.query(
      'track_sessions',
      where: 'status = ?',
      whereArgs: [TrackStatus.completed.index],
      orderBy: 'start_time DESC',
    );

    if (sessions.isEmpty) return 0;

    int streak = 0;
    DateTime? lastDate;

    for (final session in sessions) {
      final sessionDate = DateTime.fromMillisecondsSinceEpoch(
        session['start_time'] as int,
      );
      final dateOnly = DateTime(sessionDate.year, sessionDate.month, sessionDate.day);

      if (lastDate == null) {
        // 今日か昨日でなければストリークは0
        final today = DateTime.now();
        final todayOnly = DateTime(today.year, today.month, today.day);
        final diff = todayOnly.difference(dateOnly).inDays;
        if (diff > 1) return 0;
        lastDate = dateOnly;
        streak = 1;
      } else {
        final diff = lastDate.difference(dateOnly).inDays;
        if (diff == 0) {
          // 同じ日は無視
          continue;
        } else if (diff == 1) {
          // 連続
          streak++;
          lastDate = dateOnly;
        } else {
          // 途切れた
          break;
        }
      }
    }

    return streak;
  }
}
