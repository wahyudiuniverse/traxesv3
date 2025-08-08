import 'package:equatable/equatable.dart';
import 'package:traxes/model/history_order/history.order.model.dart';

abstract class HistoryOrderState extends Equatable {
  @override
  List<Object> get props => [];
}

class HistoryOrderLoading extends HistoryOrderState {}

class HistoryOrderLoaded extends HistoryOrderState {
  final List<DataHistoryOrder> data;

  HistoryOrderLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class HistoryOrderError extends HistoryOrderState {
   final String message;

  HistoryOrderError(this.message);

  @override
  List<Object> get props => [message];
}

class HistoryOrderTimeout extends HistoryOrderState {
   final String message;

  HistoryOrderTimeout(this.message);

  @override
  List<Object> get props => [message];
}



class SuccessHistoryOrder extends HistoryOrderState {
  @override
  List<Object> get props => [];
}

class HistoryOrderFailed extends HistoryOrderState {
  
}