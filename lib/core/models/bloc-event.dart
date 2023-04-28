abstract class BlocEvent<T> {
  final T payload;

  BlocEvent(this.payload);
}
