import {
  FlutterPlugin,
  FlutterPluginBinding,
  MethodCall,
  MethodCallHandler,
  MethodChannel,
  MethodResult,
  EventChannel,
  BinaryMessenger,
  StreamHandler,
  EventSink,
} from '@ohos/flutter_ohos';
import { VolumeChangeObserver, VolumeChangeListener } from './VolumeChangeObserver';
import { deviceInfo } from '@kit.BasicServicesKit';

const TAG = 'VolumeWatcherPlugin';
const CHANNEL = 'volume_watcher';

export default class VolumeWatcherPlugin implements FlutterPlugin, MethodCallHandler, StreamHandler, VolumeChangeListener {
  private volumeChangeObserver: VolumeChangeObserver | null = null;
  private eventSink: EventSink | null = null;
  private methodChannel: MethodChannel | null = null;
  private eventChannel: EventChannel | null = null;

  getUniqueClassName(): string {
    return 'VolumeWatcherPlugin';
  }

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    this.volumeChangeObserver = new VolumeChangeObserver();

    this.methodChannel = new MethodChannel(binding.getBinaryMessenger(), CHANNEL + '_method');
    this.methodChannel.setMethodCallHandler(this);

    this.eventChannel = new EventChannel(binding.getBinaryMessenger(), CHANNEL + '_event');
    this.eventChannel.setStreamHandler(this);
  }

  onDetachedFromEngine(binding: FlutterPluginBinding): void {
    if (this.methodChannel != null) {
      this.methodChannel.setMethodCallHandler(null);
      this.methodChannel = null;
    }

    if (this.eventChannel != null) {
      this.eventChannel.setStreamHandler(null);
      this.eventChannel = null;
    }

    if (this.volumeChangeObserver) {
      this.volumeChangeObserver.unregisterVolumeChangeListener();
      this.volumeChangeObserver.setVolumeChangeListener(null);
      this.volumeChangeObserver = null;
    }
  }

  onMethodCall(call: MethodCall, result: MethodResult): void {
    switch (call.method) {
      case 'getPlatformVersion':
        result.success(deviceInfo.osFullName);
        break;
      case 'getMaxVolume':
        if (this.volumeChangeObserver) {
          const maxVol: number = this.volumeChangeObserver.getMaxMusicVolume();
          console.info(TAG, `getMaxVolume returning: ${maxVol}`);
          result.success(maxVol);
        } else {
          console.error(TAG, 'VolumeChangeObserver not initialized for getMaxVolume');
          result.error('ERROR', 'VolumeChangeObserver not initialized', null);
        }
        break;
      case 'getCurrentVolume':
        if (this.volumeChangeObserver) {
          const currentVol: number = this.volumeChangeObserver.getCurrentMusicVolume();
          console.info(TAG, `getCurrentVolume returning: ${currentVol}`);
          result.success(currentVol);
        } else {
          console.error(TAG, 'VolumeChangeObserver not initialized for getCurrentVolume');
          result.error('ERROR', 'VolumeChangeObserver not initialized', null);
        }
        break;
      case 'setVolume':
        this.handleSetVolume(call, result);
        break;
      default:
        result.notImplemented();
        break;
    }
  }

  private handleSetVolume(call: MethodCall, result: MethodResult): void {
    if (!this.volumeChangeObserver) {
      result.error('ERROR', 'VolumeChangeObserver not initialized', null);
      return;
    }

    try {
      const volumeArg: string | number | null | undefined = call.argument('volume');
      if (volumeArg !== null && volumeArg !== undefined) {
        const volumeValue: number = parseFloat(volumeArg.toString());
        const success: boolean = this.volumeChangeObserver.setVolume(volumeValue);
        result.success(success);
      } else {
        result.success(false);
      }
    } catch (e) {
      console.error(TAG, `setVolume error: ${e}`);
      result.success(false);
    }
  }

  onListen(args: ESObject, eventSink: EventSink): void {
    this.eventSink = eventSink;

    if (!this.volumeChangeObserver) {
      console.error(TAG, 'VolumeChangeObserver not initialized in onListen');
      return;
    }

    this.volumeChangeObserver.setVolumeChangeListener(this);

    const volume: number = this.volumeChangeObserver.getCurrentMusicVolume();
    eventSink.success(volume);

    this.volumeChangeObserver.registerVolumeChangeListener();
  }

  onVolumeChanged(volume: number): void {
    if (this.eventSink) {
      this.eventSink.success(volume);
    }
  }

  onCancel(args: ESObject): void {
    if (this.volumeChangeObserver) {
      this.volumeChangeObserver.unregisterVolumeChangeListener();
      this.volumeChangeObserver.setVolumeChangeListener(null);
    }
    this.eventSink = null;
  }
}
