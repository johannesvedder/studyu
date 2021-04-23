// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'study.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Study _$StudyFromJson(Map<String, dynamic> json) {
  return Study(
    json['id'] as String,
    json['userId'] as String,
  )
    ..title = json['title'] as String?
    ..description = json['description'] as String?
    ..visibility = _$enumDecode(_$StudyVisibilityEnumMap, json['visibility'])
    ..contact = Contact.fromJson(json['contact'] as Map<String, dynamic>)
    ..iconName = json['iconName'] as String
    ..published = json['published'] as bool
    ..questionnaire =
        StudyUQuestionnaire.fromJson(json['questionnaire'] as List<dynamic>)
    ..eligibilityCriteria = (json['eligibilityCriteria'] as List<dynamic>)
        .map((e) => EligibilityCriterion.fromJson(e as Map<String, dynamic>))
        .toList()
    ..consent = (json['consent'] as List<dynamic>)
        .map((e) => ConsentItem.fromJson(e as Map<String, dynamic>))
        .toList()
    ..interventions = (json['interventions'] as List<dynamic>)
        .map((e) => Intervention.fromJson(e as Map<String, dynamic>))
        .toList()
    ..observations = (json['observations'] as List<dynamic>)
        .map((e) => Observation.fromJson(e as Map<String, dynamic>))
        .toList()
    ..schedule =
        StudySchedule.fromJson(json['schedule'] as Map<String, dynamic>)
    ..reportSpecification = ReportSpecification.fromJson(
        json['reportSpecification'] as Map<String, dynamic>)
    ..results = (json['results'] as List<dynamic>)
        .map((e) => StudyResult.fromJson(e as Map<String, dynamic>))
        .toList()
    ..fhirQuestionnaire = json['fhirQuestionnaire'] == null
        ? null
        : Questionnaire.fromJson(
            json['fhirQuestionnaire'] as Map<String, dynamic>);
}

Map<String, dynamic> _$StudyToJson(Study instance) {
  final val = <String, dynamic>{
    'id': instance.id,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('title', instance.title);
  writeNotNull('description', instance.description);
  val['userId'] = instance.userId;
  val['visibility'] = _$StudyVisibilityEnumMap[instance.visibility];
  val['contact'] = instance.contact.toJson();
  val['iconName'] = instance.iconName;
  val['published'] = instance.published;
  val['questionnaire'] = instance.questionnaire.toJson();
  val['eligibilityCriteria'] =
      instance.eligibilityCriteria.map((e) => e.toJson()).toList();
  val['consent'] = instance.consent.map((e) => e.toJson()).toList();
  val['interventions'] = instance.interventions.map((e) => e.toJson()).toList();
  val['observations'] = instance.observations.map((e) => e.toJson()).toList();
  val['schedule'] = instance.schedule.toJson();
  val['reportSpecification'] = instance.reportSpecification.toJson();
  val['results'] = instance.results.map((e) => e.toJson()).toList();
  writeNotNull('fhirQuestionnaire', instance.fhirQuestionnaire?.toJson());
  return val;
}

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$StudyVisibilityEnumMap = {
  StudyVisibility.public: 'public',
  StudyVisibility.private: 'private',
  StudyVisibility.organization: 'organization',
};
