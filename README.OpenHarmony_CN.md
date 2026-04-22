# volume_watcher

本项目基于 [volume_watcher](https://github.com/yangming1009/volume_watcher) 开发，为 OpenHarmony Flutter 场景提供系统音量监听与控制能力。

## 1. 安装与使用

### 1.1 安装方式

进入工程目录并在 `pubspec.yaml` 中添加依赖：

#### pubspec.yaml

```yaml
dependencies:
  volume_watcher:
    git:
      url: https://gitcode.com/org/OpenHarmony-Flutter/volume_watcher
      ref: master
```
执行命令：

```bash
flutter pub get
```

### 1.2 使用案例

使用案例详见 [example](example/lib/main.dart)。

最简单的调用方式：

```dart
import 'package:volume_watcher/volume_watcher.dart';

// 获取当前音量
double currentVolume = await VolumeWatcher.getCurrentVolume;

// 获取最大音量
double maxVolume = await VolumeWatcher.getMaxVolume;

// 设置音量（0.0 - 1.0）
await VolumeWatcher.setVolume(0.5);

// 监听音量变化
VolumeWatcher(
  onVolumeChangeListener: (double volume) {
    print('当前音量: $volume');
  },
  child: YourWidget(),
);
```

## 2. 约束条件
1. Flutter: 3.7.12-ohos-1.0.6; SDK: 5.0.0(12); IDE: DevEco Studio: 5.0.13.200; ROM: 5.1.0.120 SP3;
2. Flutter: 3.22.1-ohos-1.0.3; SDK: 5.0.0(12); IDE: DevEco Studio: 5.1.1.830; ROM: 6.0.0.115 SP16;
3. Flutter: oh-3.27.4-dev; SDK: 5.0.0(12); IDE: DevEco Studio: 5.1.0.828; ROM: 5.1.0.130 SP8;
4. Flutter: 3.35.8-ohos-0.0.1; SDK: 6.0.1 (21); IDE: DevEco Studio 6.0.1.260; ROM: 6.0.0.120 SP6

## 3. 版本和框架对应关系
|       | 3.7 | 3.22 | 3.27 | 3.35 |
|-------|:---:|:----:|:----:|:----:|
| 1.0.0 |  ✅  |  ✅   |  ✅   |  ✅   |

## 4. API

> [!TIP] "ohos Support" 列：yes 表示支持；no 表示不支持；partially 表示部分支持。

| Name | Description | Type | Input | Output | ohos Support |
| --- | --- | --- | --- | --- | --- |
| getCurrentVolume | 获取当前系统音量 | function | 无 | Future\<double\> | yes |
| getMaxVolume | 获取系统最大音量 | function | 无 | Future\<double\> | yes |
| setVolume | 设置系统音量 | function | volume: double (0.0-1.0) | Future\<bool\> | yes |
| addListener | 添加音量变化监听器 | function | onEvent: Function | int? (监听器ID) | yes |
| removeListener | 移除音量变化监听器 | function | id: int | void | yes |
| hideVolumeView | 隐藏/显示音量面板（仅iOS有效） | setter | value: bool | void | no |
| platformVersion | 获取平台版本 | function | 无 | Future\<String\> | yes |

## 5. 遗留问题

ohos暂不支持隐藏音量面板功能（hideVolumeView），该功能仅iOS平台支持。

## 6. 开源协议

本项目基于 [Apache-2.0](LICENSE) 开源。
