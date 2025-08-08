import 'package:equatable/equatable.dart';

abstract class BillState extends Equatable {
  @override
  List<Object> get props => [];
}

class BillLoading extends BillState {}

class BillSuccessInsert extends BillState {
  @override 
  List<Object> get props => [];
}
