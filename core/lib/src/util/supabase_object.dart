import 'package:postgrest/postgrest.dart';

import '../../core.dart';
import '../env/env.dart';
import '../models/tables/study.dart';

abstract class SupabaseObject {
  String? id;

  Map<String, dynamic> toJson();
}

String tableName(Type cls) {
  switch (cls) {
    case Study:
      return Study.tableName;
    case StudySubject:
      return StudySubject.tableName;
    case SubjectProgress:
      return SubjectProgress.tableName;
    case AppConfig:
      return AppConfig.tableName;
    default:
      print('$cls is not a supported Supabase type');
      throw TypeError();
  }
}

abstract class SupabaseObjectFunctions<T extends SupabaseObject> implements SupabaseObject {
  static T fromJson<T extends SupabaseObject>(Map<String, dynamic> json) {
    switch (T) {
      case Study:
        return Study.fromJson(json) as T;
      case StudySubject:
        return StudySubject.fromJson(json) as T;
      case SubjectProgress:
        return SubjectProgress.fromJson(json) as T;
      case AppConfig:
        return AppConfig.fromJson(json) as T;
      default:
        print('$T is not a supported Supabase type');
        throw TypeError();
    }
  }

  Future<T> delete() async => SupabaseQuery.extractSupabaseSingleRow<T>(
      await client.from(tableName(T)).delete().eq('id', id).single().execute());

  Future<T> save() async =>
      SupabaseQuery.extractSupabaseList<T>(await client.from(tableName(T)).insert(toJson(), upsert: true).execute())
          .single;
}

class SupabaseQuery {
  static Future<List<T>> getAll<T extends SupabaseObject>({List<String> selectedColumns = const ['*']}) async =>
      extractSupabaseList(await client.from(tableName(T)).select(selectedColumns.join(',')).execute());

  static Future<T> getById<T extends SupabaseObject>(String id, {List<String> selectedColumns = const ['*']}) async =>
      extractSupabaseSingleRow(
          await client.from(tableName(T)).select(selectedColumns.join(',')).eq('id', id).single().execute());

  static Future<List<T>> batchUpsert<T extends SupabaseObject>(List<Map<String, dynamic>> batchJson) async =>
      SupabaseQuery.extractSupabaseList<T>(await client.from(tableName(T)).insert(batchJson, upsert: true).execute());

  static List<T> extractSupabaseList<T extends SupabaseObject>(PostgrestResponse response) {
    catchPostgrestError(response.error);
    return List<T>.from(List<Map<String, dynamic>>.from(response.data as List)
        .map((json) => SupabaseObjectFunctions.fromJson<T>(json)));
  }

  static T extractSupabaseSingleRow<T extends SupabaseObject>(PostgrestResponse response) {
    catchPostgrestError(response.error);
    return SupabaseObjectFunctions.fromJson<T>(response.data as Map<String, dynamic>);
  }

  static void catchPostgrestError(PostgrestError? error) {
    if (error != null) {
      print('Error: ${error.message}');
      // ignore: only_throw_errors
      throw error.message;
    }
  }
}
