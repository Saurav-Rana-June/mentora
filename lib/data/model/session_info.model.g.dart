// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_info.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionModalityModel _$SessionModalityModelFromJson(
  Map<String, dynamic> json,
) => SessionModalityModel(
  type: json['type'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
);

Map<String, dynamic> _$SessionModalityModelToJson(
  SessionModalityModel instance,
) => <String, dynamic>{
  'type': instance.type,
  'title': instance.title,
  'description': instance.description,
};

SessionDurationModel _$SessionDurationModelFromJson(
  Map<String, dynamic> json,
) => SessionDurationModel(
  minutes: (json['minutes'] as num).toInt(),
  subtitle: json['subtitle'] as String,
  price: (json['price'] as num).toDouble(),
  videoCallPrice: (json['videoCallPrice'] as num).toDouble(),
  voiceCallPrice: (json['voiceCallPrice'] as num).toDouble(),
);

Map<String, dynamic> _$SessionDurationModelToJson(
  SessionDurationModel instance,
) => <String, dynamic>{
  'minutes': instance.minutes,
  'subtitle': instance.subtitle,
  'price': instance.price,
  'videoCallPrice': instance.videoCallPrice,
  'voiceCallPrice': instance.voiceCallPrice,
};

SessionInfoModel _$SessionInfoModelFromJson(Map<String, dynamic> json) =>
    SessionInfoModel(
      modalities: (json['modalities'] as List<dynamic>)
          .map((e) => SessionModalityModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      durations: (json['durations'] as List<dynamic>)
          .map((e) => SessionDurationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SessionInfoModelToJson(SessionInfoModel instance) =>
    <String, dynamic>{
      'modalities': instance.modalities.map((e) => e.toJson()).toList(),
      'durations': instance.durations.map((e) => e.toJson()).toList(),
    };
