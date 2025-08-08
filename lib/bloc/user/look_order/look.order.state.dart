import 'package:equatable/equatable.dart';
import 'package:traxes/model/look_order/look.order.model.dart';

abstract class LookOrderState extends Equatable {
  @override
  List<Object> get props => [];
}

class LookOrderLoading extends LookOrderState {}

class AfterOrderLoading extends LookOrderState {}

class LookOrderLoaded extends LookOrderState {
  final List<LookOrderData> data;

  LookOrderLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class LookOrderTimeout extends LookOrderState {
  final String message;

  LookOrderTimeout(this.message);
}

class LookOrderFailed extends LookOrderState {}
