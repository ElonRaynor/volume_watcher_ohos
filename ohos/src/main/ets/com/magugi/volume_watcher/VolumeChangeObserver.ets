import { audio } from '@kit.AudioKit';

const TAG = 'VolumeChangeObserver';

export interface VolumeChangeListener {
  onVolumeChanged(volume: number): void;
}

export class VolumeChangeObserver {
  private audioManager: audio.AudioManager;
  private volumeManager: audio.AudioVolumeManager;
  private volumeGroupManager: audio.AudioVolumeGroupManager | null = null;
  private volumeChangeListener: VolumeChangeListener | null = null;
  private maxVolume: number = 0;
  private isListening: boolean = false;
  private volumeChangeCallback: ((volumeEvent: audio.VolumeEvent) => void) | null = null;

  private roundToTwoDecimals(value: number): number {
    return Math.round(value * 100) / 100;
  }

  constructor() {
    this.audioManager = audio.getAudioManager();
    this.volumeManager = this.audioManager.getVolumeManager();

    try {
      this.volumeGroupManager = this.volumeManager.getVolumeGroupManagerSync(audio.DEFAULT_VOLUME_GROUP_ID);
      this.maxVolume = this.volumeGroupManager.getMaxVolumeSync(audio.AudioVolumeType.MEDIA);
      console.info(TAG, `Max volume: ${this.maxVolume}`);
    } catch (e) {
      console.error(TAG, `Failed to get volume group manager: ${e}`);
      this.maxVolume = 0;
    }
  }

  getCurrentMusicVolume(): number {
    try {
      if (this.volumeGroupManager && this.maxVolume > 0) {
        const currentVolume = this.volumeGroupManager.getVolumeSync(audio.AudioVolumeType.MEDIA);
        const normalizedVolume = currentVolume / this.maxVolume;
        return this.roundToTwoDecimals(Math.max(0, Math.min(1, normalizedVolume)));
      }
      return 0;
    } catch (e) {
      console.error(TAG, `Failed to get current volume: ${e}`);
      return 0;
    }
  }

  getMaxMusicVolume(): number {
    return 1.0;
  }


  public setVolume(volume: number): boolean {
    try {
      const clampedVolume = this.roundToTwoDecimals(Math.max(0, Math.min(1, volume)));
      const volumeLevel = Math.round(clampedVolume * this.maxVolume);
      this.audioManager.setVolume(audio.AudioVolumeType.MEDIA, volumeLevel);

      if (this.volumeChangeListener) {
        const newVolume = this.getCurrentMusicVolume();
        this.volumeChangeListener.onVolumeChanged(newVolume);
      }
      return true;
    } catch (error) {
      console.error(TAG, `setVolume error: ${error}`);
      return false;
    }
  }


  getVolumeChangeListener(): VolumeChangeListener | null {
    return this.volumeChangeListener;
  }

  setVolumeChangeListener(listener: VolumeChangeListener | null): void {
    this.volumeChangeListener = listener;
  }

  registerVolumeChangeListener(): void {
    if (this.isListening) {
      return;
    }

    try {
      this.volumeChangeCallback = (volumeEvent: audio.VolumeEvent) => {
        if (volumeEvent.volumeType === audio.AudioVolumeType.MEDIA) {
          const volume = this.getCurrentMusicVolume();
          if (volume >= 0 && this.volumeChangeListener) {
            this.volumeChangeListener.onVolumeChanged(volume);
          }
        }
      };

      this.volumeManager.on('volumeChange', this.volumeChangeCallback);
      this.isListening = true;
      console.info(TAG, 'Volume change listener registered');
    } catch (e) {
      console.error(TAG, `Failed to register volume change listener: ${e}`);
    }
  }

  unregisterVolumeChangeListener(): void {
    if (!this.isListening) {
      return;
    }

    try {
      if (this.volumeChangeCallback) {
        this.volumeManager.off('volumeChange', this.volumeChangeCallback);
        this.volumeChangeCallback = null;
      }
      this.isListening = false;
      console.info(TAG, 'Volume change listener unregistered');
    } catch (e) {
      console.error(TAG, `Failed to unregister volume change listener: ${e}`);
    }
  }
}
