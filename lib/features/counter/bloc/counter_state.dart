part of 'counter_bloc.dart';

@immutable
sealed class CounterState {}

final class CounterInitial extends CounterState {}

abstract class CounterActionState extends CounterState {}

// snackbar is not a state that is going to rebuild, thats why extending an ActionState not CounterState
class CounterShowSnackBarActionState extends CounterActionState {}

// we will be passing the value from BLoC to our UI
class CounterIncrementState extends CounterState {
  final int value;

  CounterIncrementState({required this.value});
}

class CounterIncrementActionState extends CounterState {}
