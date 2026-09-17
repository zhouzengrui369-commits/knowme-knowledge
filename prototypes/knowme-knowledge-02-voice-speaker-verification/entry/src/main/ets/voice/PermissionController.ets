import { abilityAccessCtrl, bundleManager, common, Permissions } from '@kit.AbilityKit';
import { MicState } from '../core/VoiceCore';

const PERMISSION_MIC: Permissions = 'ohos.permission.MICROPHONE';

/**
 * Honest microphone permission state. Never implies granted/recordable when
 * the system says otherwise.
 */
export class PermissionController {
  private atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();

  private tokenId(): number {
    const info = bundleManager.getBundleInfoForSelfSync(
      bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION);
    return info.appInfo.accessTokenId;
  }

  isGranted(): boolean {
    try {
      const status = this.atManager.checkAccessTokenSync(this.tokenId(), PERMISSION_MIC);
      return status === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED;
    } catch (e) {
      return false;
    }
  }

  /** Current honest mic state before any capture attempt. */
  currentState(): MicState {
    return this.isGranted() ? MicState.PERMISSION_GRANTED : MicState.PERMISSION_REQUIRED;
  }

  /**
   * Explicit user-triggered permission request. Resolves to PERMISSION_GRANTED
   * or PERMISSION_DENIED — never any other optimistic value.
   */
  async requestFromUser(context: common.UIAbilityContext): Promise<MicState> {
    try {
      const result = await this.atManager.requestPermissionsFromUser(context, [PERMISSION_MIC]);
      const granted = result.authResults.length > 0 && result.authResults[0] === 0;
      return granted ? MicState.PERMISSION_GRANTED : MicState.PERMISSION_DENIED;
    } catch (e) {
      return MicState.PERMISSION_DENIED;
    }
  }
}
