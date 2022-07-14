import 'dart:math';

import 'package:resource_provider/resource_provider.dart';

int randomValue() {
  final random = Random.secure();

  return random.nextInt(100);
}

void main() {
  var awesome = ResourceProvider();

  print(
    '1st time: ${awesome(ResourceData(onCreate: randomValue))}',
  );
  print(
    '1st time by name: ${awesome(ResourceData(onCreate: randomValue, name: 'awesome'))}',
  );
  print(
    '2nd time: ${awesome(ResourceData(onCreate: randomValue))}',
  );
  print(
    '2nd time by name: ${awesome(ResourceData(onCreate: randomValue, name: 'awesome'))}',
  );

  awesome.clear();

  print('disposed');

  print(
    '1st time: ${awesome(ResourceData(onCreate: randomValue))}',
  );
  print(
    '1st time by name: ${awesome(ResourceData(onCreate: randomValue, name: 'awesome'))}',
  );
  print(
    '2nd time: ${awesome(ResourceData(onCreate: randomValue))}',
  );
  print(
    '2nd time by name: ${awesome(ResourceData(onCreate: randomValue, name: 'awesome'))}',
  );
}
