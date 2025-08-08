import 'package:equatable/equatable.dart';
import 'package:traxes/model/skupro/skupro.model.dart';

abstract class SkuProState extends Equatable {
  @override
  List<Object> get props => [];
}

class SkuProLoading extends SkuProState {}

class SkuProLoaded extends SkuProState {
  final List<DataSkuPro> data;

  SkuProLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class LoadLocalSku extends SkuProState {
  final List<DataSkuPro> data;

  LoadLocalSku(this.data);

  @override
  List<Object> get props => [data];
}

class SkuTimeOut extends SkuProState {
  @override
  List<Object> get props => [];
}

class SkuProFailed extends SkuProState {}

class LoadLocalSkuFailed extends SkuProState {}
