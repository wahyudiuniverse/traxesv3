import 'package:equatable/equatable.dart';
import 'package:traxes/model/history_absence/history.absence.model.dart';

abstract class HistoryAbsenceState extends Equatable {
  @override
  List<Object> get props => [];
}

class HistoryAbsenceLoading extends HistoryAbsenceState {}

class HistoryAbsenceError extends HistoryAbsenceState {
  final String message;

  HistoryAbsenceError(this.message);

  @override
  List<Object> get props => [message];
}

class HistoryAbsenceToken extends HistoryAbsenceState {
  final String message;

  HistoryAbsenceToken(this.message);

  @override
  List<Object> get props => [message];
}

class HistoryAbsenceTimeOut extends HistoryAbsenceState {
  final String message;

  HistoryAbsenceTimeOut(this.message);

  @override 
  List<Object> get props => [message];
}

class HistoryAbsenceLoaded extends HistoryAbsenceState {
  final List<DataHistoryAbsence> data;

  HistoryAbsenceLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class HistoryAbsenceFailed extends HistoryAbsenceState {
}
