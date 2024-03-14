/*
A Bloc is a more advanced class which relies on events to trigger state changes rather than functions. 
Bloc also extends BlocBase which means it has a similar public API as Cubit. 
However, rather than calling a function on a Bloc and directly emitting a new state, Blocs receive events 
and convert the incoming events into outgoing states.
*/

import 'package:bloc/bloc.dart';

void main() {
  // sampleUsage();
  // streamUsage();
  withBlocObserver();
}

sealed class CounterEvent {}

final class CounterIncrementPressed extends CounterEvent {}

class CounterBloc extends Bloc<CounterEvent, int> {
  CounterBloc() : super(0) {
    on<CounterIncrementPressed>((event, emit) {
      emit(state + 1);
    });
  }

  @override
  void onEvent(CounterEvent event) {
    super.onEvent(event);
    print('local: $event');
  }

  @override
  void onChange(Change<int> change) {
    super.onChange(change);
    print('local: $change');
  }

  @override
  void onTransition(Transition<CounterEvent, int> transition) {
    super.onTransition(transition);
    print('local: $transition');
  }
}

class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    print('SimpleBlocObserver: ${bloc.runtimeType} $event');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print('SimpleBlocObserver: ${bloc.runtimeType} $change');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print('SimpleBlocObserver: ${bloc.runtimeType} $transition');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print('SimpleBlocObserver: ${bloc.runtimeType} $error $stackTrace');
    super.onError(bloc, error, stackTrace);
  }
}

// test functions --------------------------------------------

void sampleUsage() async {
  print('sample usage');
  final bloc = CounterBloc();
  print(bloc.state);
  bloc.add(CounterIncrementPressed());

  // await Future.delayed(Duration.zero) is added to ensure we wait for the next event-loop iteration
  // (allowing the EventHandler to process the event).
  await Future.delayed(Duration.zero);
  print(bloc.state);
  bloc.close();
}

void streamUsage() async {
  print('stream usage');
  final bloc = CounterBloc();
  final subscription = bloc.stream.listen((state) {
    print(state);
  });
  bloc.add(CounterIncrementPressed());
  await Future.delayed(Duration(seconds: 1));
  bloc.add(CounterIncrementPressed());
  await Future.delayed(Duration.zero);
  subscription.cancel();
  bloc.close();
}

void withBlocObserver() {
  Bloc.observer = SimpleBlocObserver();
  CounterBloc()
    ..add(CounterIncrementPressed())
    ..close();
}
