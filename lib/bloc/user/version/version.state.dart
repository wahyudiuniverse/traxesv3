import 'package:equatable/equatable.dart';


abstract class VersionState extends Equatable {
  @override
  List<Object> get props => [];
}

class VersionLoading extends VersionState {}

class VersionSuccess extends VersionState {
  @override
  List<Object> get props => [];
}

class VersionFailed extends VersionState {
  
}


class UpdateNotification extends VersionState {
  final String message;

  UpdateNotification(this.message);

  @override
  List<Object> get props => [message];
}