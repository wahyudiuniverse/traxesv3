import 'package:equatable/equatable.dart';
import 'package:traxes/model/project_radius/project.radius.response.model.dart';

abstract class ProjectRadiusState extends Equatable {
  @override 
  List<Object> get props => [];
}

class ProjectRadiusLoading extends ProjectRadiusState {}

class ProjectRadiusSuccess extends ProjectRadiusState {
  final List<DataProjectRadius> data;

  ProjectRadiusSuccess(this.data);

  @override
  List<Object> get props =>[data];
  
}

class FailedProjectRadius extends ProjectRadiusState{
  final String error;
  FailedProjectRadius(this.error);
}