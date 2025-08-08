import 'package:equatable/equatable.dart';
import 'package:traxes/model/sku/sku.model.dart';

abstract class SkuState extends Equatable {
  @override
  List<Object> get props => [];
}

class SkuLoading extends SkuState {}

class SkuLoaded extends SkuState {
  final List<DataSKU> data;

  SkuLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class SkuSuccessInsert extends SkuState {
  @override
  List<Object> get props => [];
}

class SkuLoadedFailed extends SkuState {}

class LoadLocalSkuFailed extends SkuState {}
