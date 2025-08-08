import 'package:equatable/equatable.dart';
import 'package:traxes/model/login/employee.model.dart';

abstract class EmployeeState extends Equatable {
  @override
  List<Object> get props => [];
}

class EmployeeLoading extends EmployeeState {}

class EmployeeNotLoaded extends EmployeeState {}

class EmployeeSuccess extends EmployeeState {
  @override
  List<Object> get props => [];
}

class EmployeeLoaded extends EmployeeState {
  final List<DataEmployee> data;

  EmployeeLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class EmployeeFailed extends EmployeeState {
  @override
  List<Object> get props => [];
}
