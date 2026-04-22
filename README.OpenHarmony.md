# volume_watcher

This project is based on [volume_watcher](https://github.com/yangming1009/volume_watcher) and provides system volume monitoring and control capabilities for OpenHarmony Flutter scenarios.

## 1. Installation and Usage

### 1.1 Installation

Add the dependency in your `pubspec.yaml`:

#### pubspec.yaml

```yaml
dependencies:
  volume_watcher:
    git:
      url: https://gitcode.com/org/OpenHarmony-Flutter/volume_watcher
      ref: master
```
Run the command:

```bash
flutter pub get
```

### 1.2 Usage Example

See [example](example/lib/main.dart) for more details.

The simplest usage:

```dart
import 'package:volume_watcher/volume_watcher.dart';

// Get current volume
double currentVolume = await VolumeWatcher.getCurrentVolume;

// Get maximum volume
double maxVolume = await VolumeWatcher.getMaxVolume;

// Set volume (0.0 - 1.0)
await VolumeWatcher.setVolume(0.5);

// Listen to volume changes
VolumeWatcher(
  onVolumeChangeListener: (double volume) {
    print('Current volume: $volume');
  },
  child: YourWidget(),
);
```

## 2. Constraints
1. Flutter: 3.7.12-ohos-1.0.6; SDK: 5.0.0(12); IDE: DevEco Studio: 5.0.13.200; ROM: 5.1.0.120 SP3;
2. Flutter: 3.22.1-ohos-1.0.3; SDK: 5.0.0(12); IDE: DevEco Studio: 5.1.1.830; ROM: 6.0.0.115 SP16;
3. Flutter: oh-3.27.4-dev; SDK: 5.0.0(12); IDE: DevEco Studio: 5.1.0.828; ROM: 5.1.0.130 SP8;
4. Flutter: 3.35.8-ohos-0.0.1; SDK: 6.0.1 (21); IDE: DevEco Studio 6.0.1.260; ROM: 6.0.0.120 SP6

## 3. Version and Framework Mapping
|       | 3.7 | 3.22 | 3.27 | 3.35 |
|-------|:---:|:----:|:----:|:----:|
| 1.0.0 |  ✅  |  ✅   |  ✅   |  ✅   |

## 4. API

> [!TIP] "ohos Support" column: yes means supported; no means not supported; partially means partially supported.

| Name | Description | Type | Input | Output | ohos Support |
| --- | --- | --- | --- | --- | --- |
| getCurrentVolume | Get current system volume | function | none | Future\<double\> | yes |
| getMaxVolume | Get maximum system volume | function | none | Future\<double\> | yes |
| setVolume | Set system volume | function | volume: double (0.0-1.0) | Future\<bool\> | yes |
| addListener | Add volume change listener | function | onEvent: Function | int? (listener ID) | yes |
| removeListener | Remove volume change listener | function | id: int | void | yes |
| hideVolumeView | Hide/show volume panel (iOS only) | setter | value: bool | void | no |
| platformVersion | Get platform version | function | none | Future\<String\> | yes |

## 5. Known Issues

ohos does not support hiding volume panel (hideVolumeView), this feature is only available on iOS platform.

## 6. License

This project is open-sourced under the [Apache-2.0](LICENSE) license.
