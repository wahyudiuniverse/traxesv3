import 'package:equatable/equatable.dart';

abstract class PermissionState extends Equatable {
  @override
  List<Object> get props => [];
}

class PermissionLoading extends PermissionState {}

class PermissionSuccess extends PermissionState {
  @override
  List<Object> get props => [];
}

class PermissionTimeOut extends PermissionState {
  final String message;

  PermissionTimeOut(this.message);

  @override
  List<Object> get props => [message];
}

class PermissionFailed extends PermissionState {}
