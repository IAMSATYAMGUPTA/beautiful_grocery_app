part of 'like_bloc.dart';

@immutable
abstract class LikeEvent {}

class AddLikeItem extends LikeEvent{
  LikeModel likeItem;
  AddLikeItem({required this.likeItem});
}

class DeleteLikeItem extends LikeEvent{
  String id;
  DeleteLikeItem({required this.id});
}