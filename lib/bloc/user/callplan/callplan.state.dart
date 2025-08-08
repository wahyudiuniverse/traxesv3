import 'package:equatable/equatable.dart';
import 'package:traxes/model/callplan/callplan.model.dart';

abstract class CallplanState extends Equatable {
  @override
  List<Object> get props => [];
}

class CallplanLoading extends CallplanState {}

class CallplanLoaded extends CallplanState {
  final List<DataCallplan> data;

  CallplanLoaded(this.data);
  
  @override
  List<Object> get props => [data];
}

class CallplanFailed extends CallplanState {}