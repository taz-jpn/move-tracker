import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/location_point.dart';
import '../models/track_session.dart';
import '../models/score_summary.dart';

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
      version: 1,
      onCreate: _onCreate,
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
        total_score REAL DEFAULT 0
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
      'last_updated': DateTime.now().millisecondsSinceEpoch,
    });
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
}
