import 'package:equatable/equatable.dart';
import 'package:traxes/model/history_outlet/history.outlet.model.dart';

abstract class LocalOutletState extends Equatable {
  @override
  List<Object> get props => [];
}

class LocalOutletLoading extends LocalOutletState {}

class LocalOutletLoaded extends LocalOutletState {
  final List<DataHistoryOutlet> data;

  LocalOutletLoaded (this.data);

  @override
  List<Object> get props => [data];
}

class HistoryOutletFailed extends LocalOutletState {
  @override 
  List<Object> get props => [];
}