import 'package:equatable/equatable.dart';
import 'package:traxes/model/search/search.model.dart';

abstract class SearchState extends Equatable {
  @override
  List<Object> get props => [];
}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<DataSearch> data;

  SearchLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class SearchLoadedFailed extends SearchState {}


