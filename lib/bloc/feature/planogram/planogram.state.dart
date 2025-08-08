import 'package:equatable/equatable.dart';

abstract class PlanogramState extends Equatable {
  @override
  List<Object> get props => [];
}

class PlanogramLoading extends PlanogramState {}

class PlanogramSuccessInsert extends PlanogramState {
  @override 
  List<Object> get props => [];
}
