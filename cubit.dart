import 'package:bloc/bloc.dart';

void main() {
  // sampleUsage();
  // streamUsage();
  // cascadeTest();
  useBlocObserver();
}

class CounterCubit extends Cubit<int> {
  CounterCubit(int initialState) : super(initialState);

  void increment() => emit(state + 1);
  void decrement() => emit(state - 1);
  void increaseWithError() {
    addError(Exception('increment error!'), StackTrace.current);
    emit(state + 1);
  }

  @override
  void onChange(Change<int> change) {
    super.onChange(change);
    print(change);
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    print('observe on cubit:$error $stackTrace');
    super.onError(error, stackTrace);
  }
}

class SimpleBlocObserver extends BlocObserver {
  /*
    One added bonus of using the bloc library is that we can have access to all Changes in one place. 
    Even though in this application we only have one Cubit, it’s fairly common in larger applications to have 
    many Cubits managing different parts of the application’s state.
  */
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print('${bloc.runtimeType} $change');
  }

  // onError can also be overridden in BlocObserver to handle all reported errors globally.
  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print('observe on blocObserver: ${bloc.runtimeType} $error $stackTrace');
    super.onError(bloc, error, stackTrace);
  }
}

// test functions --------------------------------------------

void sampleUsage() {
  print('sample usage');
  final cubit = CounterCubit(5);
  print(cubit.state);
  cubit.increment();
  print(cubit.state);
  cubit.decrement();
  print(cubit.state);
  cubit.increaseWithError();
  print(cubit.state);
  cubit.increment();
  print(cubit.state);
  cubit.close();
}

void streamUsage() async {
  print('stream usage');
  final cubit = CounterCubit(5);
  final subscription = cubit.stream.listen((state) {
    print(state);
  });
  cubit.increment();
  await Future.delayed(Duration(seconds: 1));
  cubit.decrement();
  subscription.cancel();
  cubit.close();
}

void cascadeTest() {
  print('cascade test');
  CounterCubit(2)
    ..increment()
    ..close();
}

void useBlocObserver() {
  Bloc.observer = SimpleBlocObserver();
  final cubit = CounterCubit(5);
  cubit.increment();
  cubit.decrement();
  cubit.increaseWithError();
  cubit.increment();
  cubit.close();
}
