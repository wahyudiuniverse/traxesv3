import 'package:equatable/equatable.dart';
import 'package:traxes/model/display_mbd/get/display.mbd.response.model.dart';

abstract class DisplayMbdState extends Equatable {
  @override
  List<Object> get props => [];
}

class DisplayMbdLoading extends DisplayMbdState{}

class DisplayMbdLoaded extends DisplayMbdState {
  final List<DataDisplayMbd> data;

  DisplayMbdLoaded(this.data);

  @override 
  List<Object> get props => [data];
}

class DisplayMbdSuccess extends DisplayMbdState {
  @override 
  List<Object> get props => [];
}