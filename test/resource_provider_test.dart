import 'package:resource_provider/resource_provider.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    late ResourceProvider resource;

    setUp(() {
      resource = ResourceProvider();
    });

    tearDown(() {
      resource.clear();
    });

    test('gets value and checks equality', () {
      expect(resource.get<int>(onCreate: () => 3), 3);
      expect(resource.get<int>(onCreate: () => 2) == 2, false);
      resource.clear();
      expect(resource.get<int>(onCreate: () => 2), 2);
    });

    test('gets value with name & type type and checks equality', () {
      expect(resource.get(onCreate: () => 3) == 3, true);
      expect(resource.get(name: 'four', onCreate: () => 4) == 4, true);
      expect(resource.get(onCreate: () => 3) == 3, true);
    });

    test('gets value with name & type type and checks equality', () {
      expect(resource.get(onCreate: () => 3) == 3, true);
      expect(resource.get(name: 'four', onCreate: () => 4) == 4, true);
      expect(resource.get(onCreate: () => 3) == 3, true);

      expect(resource.get(onCreate: () => 3, value: 4) == 4, true);
      expect(
          resource.get(name: 'four', onCreate: () => 4, value: 5) == 5, true);
      expect(resource.get(onCreate: () => 3) == 4, true);
      expect(resource.get(name: 'four', onCreate: () => 4) == 5, true);
    });
  });
}
