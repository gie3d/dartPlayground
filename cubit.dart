import 'package:bloc/bloc.dart';

void main() {
  // sampleUsage();
  streamUsage();
}

void sampleUsage() {
  print('sample usage');
  final cubit = CounterCubit(5);
  print(cubit.state);
  cubit.increment();
  print(cubit.state);
  cubit.decrement();
  print(cubit.state);
  cubit.close();
}

void streamUsage() {
  print('stream usage');
  final cubit = CounterCubit(5);
  cubit.stream.listen((state) {
    print(state);
  });
  cubit.increment();
  cubit.decrement();
  cubit.close();
}

class CounterCubit extends Cubit<int> {
  CounterCubit(int initialState) : super(initialState);

  void increment() => emit(state + 1);
  void decrement() => emit(state - 1);
}
