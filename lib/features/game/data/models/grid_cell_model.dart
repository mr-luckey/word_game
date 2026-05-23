import 'package:equatable/equatable.dart';

class GridCellModel extends Equatable {
  const GridCellModel({
    required this.row,
    required this.col,
    required this.letter,
    this.isHint = false,
    this.isRevealed = false,
  });

  final int row;
  final int col;
  final String letter;
  final bool isHint;
  final bool isRevealed;

  GridCellModel copyWith({
    String? letter,
    bool? isHint,
    bool? isRevealed,
  }) =>
      GridCellModel(
        row: row,
        col: col,
        letter: letter ?? this.letter,
        isHint: isHint ?? this.isHint,
        isRevealed: isRevealed ?? this.isRevealed,
      );

  @override
  List<Object?> get props => [row, col, letter, isHint, isRevealed];
}

class WordModel extends Equatable {
  const WordModel({
    required this.text,
    this.isFound = false,
    this.isRevealed = false,
  });

  final String text;
  final bool isFound;
  final bool isRevealed;

  WordModel copyWith({bool? isFound, bool? isRevealed}) => WordModel(
        text: text,
        isFound: isFound ?? this.isFound,
        isRevealed: isRevealed ?? this.isRevealed,
      );

  @override
  List<Object?> get props => [text, isFound, isRevealed];
}
