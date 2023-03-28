import 'package:freezed_annotation/freezed_annotation.dart';
part 'finans.g.dart';
part 'finans.freezed.dart';

//
@freezed
class Note with _$Note {
  const factory Note(
      {required String name,
      required String text,
      required String category,
      int? number,
      String? status,
      required String amount}) = _Note;

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);
}
