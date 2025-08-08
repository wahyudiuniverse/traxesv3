import 'package:equatable/equatable.dart';
import 'package:traxes/model/filter_mbd/filter.mbd.model.dart';

abstract class FilterMbdState extends Equatable {
  @override
  List<Object> get props => [];
}

class FilterMbdLoading extends FilterMbdState {}

class FilterMbdLoaded extends FilterMbdState {
  final List<DataFilterMbd> data;

  FilterMbdLoaded(this.data);

  @override 
  List<Object> get props => [data];
  
}

class FilterMbdFailed extends FilterMbdState {}