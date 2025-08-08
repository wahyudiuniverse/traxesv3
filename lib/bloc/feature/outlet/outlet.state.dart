import 'package:equatable/equatable.dart';

abstract class OutletState extends Equatable {
  @override
  List<Object> get props => [];
}

class OutletLoading extends OutletState {}

class OutletSubmitSuccess extends OutletState {
  @override
  List<Object> get props => [];
}

class OutletSubmitFailed extends OutletState{}
