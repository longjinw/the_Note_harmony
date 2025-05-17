import { abilityAccessCtrl, bundleManager, common, Permissions } from '@kit.AbilityKit';

export class PermissionManager {
  // Static method to check if the given permissions are granted
  static checkPermission(permissions: Permissions[]): boolean {
    let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
    let tokenID: number = 0;

    const bundleInfo =
      bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION);

    tokenID = bundleInfo.appInfo.accessTokenId;

    if (permissions.length === 0) {
      return false;
    } else {
      return permissions.every(permission =>
        abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED ===
        atManager.checkAccessTokenSync(tokenID, permission)
      );
    }
  }

  // Async static method to request user authorization for specified permissions
  static async requestPermission(permissions: Permissions[]): Promise<boolean> {
    let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();

    let context: Context = getContext() as common.UIAbilityContext;

    const result = await atManager.requestPermissionsFromUser(context, permissions);

    return !!result.authResults.length && result.authResults.every(authResults => authResults === 0);
  }
} 