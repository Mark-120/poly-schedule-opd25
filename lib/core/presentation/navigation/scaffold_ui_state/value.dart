class Value<T> {
  final T? value;
  final bool isSet;

  const Value.set(this.value) : isSet = true;
  const Value.unset() : value = null, isSet = false;
}
