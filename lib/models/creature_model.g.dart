// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'creature_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreatureModel _$CreatureModelFromJson(Map<String, dynamic> json) =>
    CreatureModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      type: $enumDecode(_$CreatureTypeEnumMap, json['type']),
      stage: $enumDecodeNullable(_$CreatureStageEnumMap, json['stage']) ??
          CreatureStage.egg,
      level: (json['level'] as num?)?.toInt() ?? 1,
      experience: (json['experience'] as num?)?.toInt() ?? 0,
      experienceToNextLevel: (json['experienceToNextLevel'] as num?)?.toInt(),
      obtainedAt: DateTime.parse(json['obtainedAt'] as String),
      lastFed: json['lastFed'] == null
          ? null
          : DateTime.parse(json['lastFed'] as String),
    );

Map<String, dynamic> _$CreatureModelToJson(CreatureModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'name': instance.name,
      'type': _$CreatureTypeEnumMap[instance.type]!,
      'stage': _$CreatureStageEnumMap[instance.stage]!,
      'level': instance.level,
      'experience': instance.experience,
      'experienceToNextLevel': instance.experienceToNextLevel,
      'obtainedAt': instance.obtainedAt.toIso8601String(),
      'lastFed': instance.lastFed?.toIso8601String(),
    };

const _$CreatureTypeEnumMap = {
  CreatureType.fire: 'fire',
  CreatureType.water: 'water',
  CreatureType.earth: 'earth',
  CreatureType.air: 'air',
  CreatureType.nature: 'nature',
};

const _$CreatureStageEnumMap = {
  CreatureStage.egg: 'egg',
  CreatureStage.baby: 'baby',
  CreatureStage.teen: 'teen',
  CreatureStage.adult: 'adult',
  CreatureStage.legendary: 'legendary',
};
