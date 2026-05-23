import 'package:equatable/equatable.dart';

abstract class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object?> get props => [];
}

class LoadLevel extends GameEvent {
  const LoadLevel(this.levelId);
  final int levelId;

  @override
  List<Object?> get props => [levelId];
}

class CellDragStarted extends GameEvent {
  const CellDragStarted({required this.row, required this.col});
  final int row;
  final int col;

  @override
  List<Object?> get props => [row, col];
}

class CellDragUpdated extends GameEvent {
  const CellDragUpdated({required this.row, required this.col});
  final int row;
  final int col;

  @override
  List<Object?> get props => [row, col];
}

class CellDragEnded extends GameEvent {
  const CellDragEnded();
}

class HintRequested extends GameEvent {
  const HintRequested();
}

class RevealRequested extends GameEvent {
  const RevealRequested();
}

class BoardRotated extends GameEvent {
  const BoardRotated();
}

class ShuffleRequested extends GameEvent {
  const ShuffleRequested();
}

class GamePaused extends GameEvent {
  const GamePaused();
}

class GameResumed extends GameEvent {
  const GameResumed();
}

class GameTick extends GameEvent {
  const GameTick();
}
