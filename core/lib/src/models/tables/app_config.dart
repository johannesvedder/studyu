import 'package:json_annotation/json_annotation.dart';

import '../../../core.dart';
import '../../util/supabase_object.dart';
import '../contact.dart';

part 'app_config.g.dart';

@JsonSerializable()
class AppConfig extends SupabaseObjectFunctions<AppConfig> {
  static const String tableName = 'app_config';

  @override
  Map<String, dynamic> get primaryKeys => {'id': id};

  String id;
  Contact contact;
  @JsonKey(name: 'app_privacy')
  Map<String, String> appPrivacy;
  @JsonKey(name: 'app_terms')
  Map<String, String> appTerms;
  @JsonKey(name: 'designer_privacy')
  Map<String, String> designerPrivacy;
  @JsonKey(name: 'designer_terms')
  Map<String, String> designerTerms;
  Map<String, String> imprint;

  AppConfig(this.id,
      {required this.contact,
      required this.appPrivacy,
      required this.appTerms,
      required this.designerPrivacy,
      required this.designerTerms,
      required this.imprint});

  factory AppConfig.fromJson(Map<String, dynamic> json) => _$AppConfigFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AppConfigToJson(this);

  static Future<AppConfig> getAppConfig() async => SupabaseQuery.getById<AppConfig>('prod');

  static Future<Contact> getAppContact() async {
    return (await getAppConfig()).contact;
  }
}
