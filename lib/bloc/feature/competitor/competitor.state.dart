import 'package:equatable/equatable.dart';

abstract class CompetitorState extends Equatable {
  @override
  List<Object> get props => [];
}

class CompetitorLoading extends CompetitorState {}

class SuccesSubmitCompetitor extends CompetitorState {
  @override
  List<Object> get props => [];
}

class FailedSubmitCompetitor extends CompetitorState {}