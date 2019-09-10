// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remote.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Suggestions _$SuggestionsFromJson(Map<String, dynamic> json) {
  return Suggestions(
    (json['suggestions'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$SuggestionsToJson(Suggestions instance) =>
    <String, dynamic>{
      'suggestions': instance.suggestions,
    };

LyricsResponse _$LyricsResponseFromJson(Map<String, dynamic> json) {
  return LyricsResponse(
    json['Lyrics'] == null
        ? null
        : LyricsObject.fromJson(json['Lyrics'] as Map<String, dynamic>),
    (json['Alternatives'] as List)
        ?.map((e) =>
            e == null ? null : Alternative.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$LyricsResponseToJson(LyricsResponse instance) =>
    <String, dynamic>{
      'Lyrics': instance.lyrics,
      'Alternatives': instance.alternatives,
    };

LyricsObject _$LyricsObjectFromJson(Map<String, dynamic> json) {
  return LyricsObject(
    json['Lyrics'] as String,
    json['Title'] as String,
  );
}

Map<String, dynamic> _$LyricsObjectToJson(LyricsObject instance) =>
    <String, dynamic>{
      'Lyrics': instance.lyrics,
      'Title': instance.title,
    };

Alternative _$AlternativeFromJson(Map<String, dynamic> json) {
  return Alternative(
    json['Url'] as String,
    json['Title'] as String,
  );
}

Map<String, dynamic> _$AlternativeToJson(Alternative instance) =>
    <String, dynamic>{
      'Url': instance.url,
      'Title': instance.title,
    };
