import 'package:equatable/equatable.dart';
import 'package:traxes/model/history_outlet/history.outlet.model.dart';

abstract class HistoryOutletState extends Equatable {
  @override
  List<Object> get props => [];
}

class HistoryOutletLoading extends HistoryOutletState {}

class HistoryOutletSuccessLoad extends HistoryOutletState {
  final List<DataHistoryOutlet> data;

  HistoryOutletSuccessLoad(this.data);

  @override
  List<Object> get props => [data];
}

class HistoryOutletTimeout extends HistoryOutletState {
  final String message;
  
  HistoryOutletTimeout(this.message);

  @override 
  List<Object> get props => [message];
}

class HistoryOutletMaxAttempt extends HistoryOutletState {
  final String message;
  
  HistoryOutletMaxAttempt(this.message);

  @override
  List<Object> get props => [message];
}

class HistoryOutletError extends HistoryOutletState {
  final String message;
  
  HistoryOutletError(this.message);

  @override
  List<Object> get props => [message];
}

class HistoryOutletFailed extends HistoryOutletState {
  @override
  List<Object> get props => [];
}
