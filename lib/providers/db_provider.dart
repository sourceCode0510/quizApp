import '../services/database_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final dbProvider = StateProvider<DatabaseService>((ref) => DatabaseService.instance);