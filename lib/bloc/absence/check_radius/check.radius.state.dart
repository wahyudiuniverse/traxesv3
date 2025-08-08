import 'package:equatable/equatable.dart';

abstract class CheckRadiusState extends Equatable {
  @override
  List<Object> get props => [];
}

class CheckRadiusLoading extends CheckRadiusState {}

class SuccessCheckRadius extends CheckRadiusState{
  @override
  List<Object> get props => [];
}

class FailureCheckRadius extends CheckRadiusState {
  final String error;
  FailureCheckRadius(this.error);
}
