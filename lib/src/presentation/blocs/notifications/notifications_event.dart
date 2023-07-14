part of 'notifications_bloc.dart';

abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object> get props => [];
}


class NotifiactionsStatusChange extends NotificationsEvent {
  final AuthorizationStatus status;
  NotifiactionsStatusChange(this.status);
}