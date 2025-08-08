import 'package:equatable/equatable.dart';
import 'package:traxes/model/history_detail_absence/history.detail.absence.model.dart';

abstract class HistoryDetailState extends Equatable {
  @override
  List<Object> get props => [];
}

class HistoryDetailLoading extends HistoryDetailState {}

class HistoryDetailLoaded extends HistoryDetailState {
  final List<DetailAbsenceData> data;

  HistoryDetailLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class HistoryDetailTimeOut extends HistoryDetailState {
  final String message;

  HistoryDetailTimeOut(this.message);

  @override 
  List<Object> get props => [message];
}

class HistoryDetailFailed extends HistoryDetailState {}