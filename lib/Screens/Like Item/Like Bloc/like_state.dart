part of 'like_bloc.dart';

@immutable
abstract class LikeState {}

class LikeInitialState extends LikeState {}

class LikeLoadingState extends LikeState {}

class LikeLoadedState extends LikeState {
  List<Map<String,dynamic>> likeItemList;
  LikeLoadedState({required this.likeItemList});
}

class LikeErrorState extends LikeState {
  String errorMsg;
  LikeErrorState({required this.errorMsg});
}