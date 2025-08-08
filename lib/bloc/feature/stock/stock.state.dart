import 'package:equatable/equatable.dart';
import 'package:traxes/model/stock/stock.model.dart';

abstract class StockState extends Equatable {
  @override
  List<Object> get props => [];
}

class StockUpdateLoading extends StockState {}

class StockLoading extends StockState {}

class StockLoaded extends StockState {
  final List<StockData> data;

  StockLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class StockUpdated extends StockState {
  @override
  List<Object> get props => [];
}

class InsertSuccess extends StockState {
  @override
  List<Object> get props => [];
}



class StockFailed extends StockState {}
