import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volume_watcher/volume_watcher.dart';

void main() {
  const MethodChannel channel = MethodChannel('volume_watcher_method');
  final List<MethodCall> methodCalls = <MethodCall>[];

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    methodCalls.clear();
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      methodCalls.add(methodCall);
      switch (methodCall.method) {
        case 'getPlatformVersion':
          return 'OpenHarmony 5.0';
        case 'getMaxVolume':
          return 15;
        case 'getCurrentVolume':
          return 7.0;
        case 'setVolume':
          return true;
        default:
          return null;
      }
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('XTS: getPlatformVersion returns harmony version string', () async {
    final String version = await VolumeWatcher.platformVersion;

    expect(version, 'OpenHarmony 5.0');
    expect(methodCalls.single.method, 'getPlatformVersion');
  });

  test('XTS: getMaxVolume and getCurrentVolume map to double', () async {
    final double maxVolume = await VolumeWatcher.getMaxVolume;
    final double currentVolume = await VolumeWatcher.getCurrentVolume;

    expect(maxVolume, 15.0);
    expect(currentVolume, 7.0);
    expect(
      methodCalls.map((MethodCall call) => call.method).toList(),
      <String>['getMaxVolume', 'getCurrentVolume'],
    );
    expect(methodCalls[0].arguments, <String, dynamic>{});
    expect(methodCalls[1].arguments, <String, dynamic>{});
  });

  test('XTS: setVolume uses expected method arguments', () async {
    final bool ok = await VolumeWatcher.setVolume(10.0);

    expect(ok, isTrue);
    expect(methodCalls.single.method, 'setVolume');
    expect(
      methodCalls.single.arguments,
      <String, dynamic>{'volume': 10.0},
    );
  });
}
