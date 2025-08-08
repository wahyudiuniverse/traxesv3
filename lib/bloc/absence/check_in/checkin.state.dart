import 'package:equatable/equatable.dart';

abstract class CheckInState extends Equatable {
  @override
  List<Object> get props => [];
}

class SubmitCheckInLoading extends CheckInState {}

class SubmitCheckInSuccess extends CheckInState {
  @override
  List<Object> get props => [];
}

class SubmitResetCheckInSuccess extends CheckInState {
  @override
  List<Object> get props => [];
}

class SubmitCheckInFailed extends CheckInState {}
