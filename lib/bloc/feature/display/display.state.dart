import 'package:equatable/equatable.dart';

abstract class DisplayState extends Equatable {
  @override
  List<Object> get props => [];
}

class DisplayLoading extends DisplayState {}

class DisplaySuccessInsert extends DisplayState {
  @override
  List<Object> get props => [];
}
