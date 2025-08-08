import 'package:equatable/equatable.dart';

abstract class CheckOutState extends Equatable {
  @override
  List<Object> get props => [];
}

class SubmitCheckOutLoading extends CheckOutState {}

class SubmitCheckOutSuccess extends CheckOutState {
  @override
  List<Object> get props => [];
}

class SubmitCheckOutFailed extends CheckOutState {}
      