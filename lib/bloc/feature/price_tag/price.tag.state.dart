import 'package:equatable/equatable.dart';
import 'package:traxes/model/price_tag/price.tag.data.model.dart';

abstract class PriceTagState extends Equatable {
@override
List<Object> get props => [];
}

class PriceTagLoading extends PriceTagState {}

class PriceTagLoaded extends PriceTagState {
  final List<PriceTagData> data;

  PriceTagLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class SuccessInsertPriceTag extends PriceTagState{
  @override
  List<Object> get props => [];
}