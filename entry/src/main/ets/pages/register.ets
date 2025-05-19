import router from '@ohos.router';
import common from '@ohos.app.ability.common';
import promptAction from '@ohos.promptAction';
import { ThemeManager } from '../common/ThemeManager';
import { UserManager } from '../common/UserManager';

@Entry
@Component
struct Register {
  @State isDarkMode: boolean = false;
  @State username: string = '';
  @State password: string = '';
  @State confirmPassword: string = '';
  private context = getContext(this) as common.UIAbilityContext;
  private themeManager: ThemeManager = ThemeManager.getInstance(this.context);
  private userManager: UserManager = UserManager.getInstance(this.context);

  aboutToAppear() {
    // 初始化主题
    this.isDarkMode = this.themeManager.getIsDarkMode();
    this.themeManager.addListener((isDarkMode: boolean) => {
      this.isDarkMode = isDarkMode;
    });

    // 初始化用户管理器
    this.userManager.init().then(error => {
      if (error) {
        promptAction.showToast({ message: error });
      }
    });
  }

  aboutToDisappear() {
    this.themeManager.removeListener();
  }

  async handleRegister() {
    if (!this.username || !this.password || !this.confirmPassword) {
      promptAction.showToast({ message: '请填写完整信息' });
      return;
    }

    if (this.password !== this.confirmPassword) {
      promptAction.showToast({ message: '两次输入的密码不一致' });
      return;
    }

    const result = await this.userManager.registerUser(this.username, this.password);
    promptAction.showToast({ message: result.message });
    if (result.success) {
      router.back();
    }
  }

  build() {
    Column() {
      // Top bar with back button
      Row() {
        Button({ type: ButtonType.Circle }) {
          Image($r('app.media.ic_public_back'))
            .width(28)
            .height(28)
            .fillColor(this.isDarkMode ? $r('app.color.ohos_id_color_text_primary_dark') : $r('app.color.ohos_id_color_text_primary'))
        }
        .width(44)
        .height(44)
        .margin({ left: 20 })
        .backgroundColor(this.isDarkMode ? $r('app.color.ohos_id_color_background_secondary_dark') : $r('app.color.ohos_id_color_background_secondary'))
        .shadow({ radius: 8, color: this.isDarkMode ? $r('app.color.ohos_id_color_shadow_dark') : $r('app.color.ohos_id_color_shadow'), offsetY: 2 })
        .onClick(() => {
          router.back()
        })

        Text('注册账号')
          .fontSize(28)
          .fontWeight(FontWeight.Bold)
          .margin({ left: 20 })
          .fontColor(this.isDarkMode ? $r('app.color.ohos_id_color_text_primary_dark') : $r('app.color.ohos_id_color_text_primary'))
      }
      .width('100%')
      .height(64)
      .backgroundColor(this.isDarkMode ? $r('app.color.ohos_id_color_background_primary_dark') : $r('app.color.ohos_id_color_background_primary'))
      .shadow({ radius: 8, color: this.isDarkMode ? $r('app.color.ohos_id_color_shadow_dark') : $r('app.color.ohos_id_color_shadow'), offsetY: 2 })

      // Registration form
      Column() {
        // Username input
        TextInput({ placeholder: '请输入账号' })
          .width('90%')
          .height(50)
          .margin({ top: 40 })
          .backgroundColor(this.isDarkMode ? $r('app.color.ohos_id_color_background_secondary_dark') : $r('app.color.ohos_id_color_background_secondary'))
          .borderRadius(25)
          .padding({ left: 20, right: 20 })
          .fontColor(this.isDarkMode ? $r('app.color.ohos_id_color_text_primary_dark') : $r('app.color.ohos_id_color_text_primary'))
          .onChange((value: string) => {
            this.username = value;
          })

        // Password input
        TextInput({ placeholder: '请输入密码' })
          .width('90%')
          .height(50)
          .margin({ top: 20 })
          .backgroundColor(this.isDarkMode ? $r('app.color.ohos_id_color_background_secondary_dark') : $r('app.color.ohos_id_color_background_secondary'))
          .borderRadius(25)
          .padding({ left: 20, right: 20 })
          .fontColor(this.isDarkMode ? $r('app.color.ohos_id_color_text_primary_dark') : $r('app.color.ohos_id_color_text_primary'))
          .type(InputType.Password)
          .onChange((value: string) => {
            this.password = value;
          })

        // Confirm password input
        TextInput({ placeholder: '请确认密码' })
          .width('90%')
          .height(50)
          .margin({ top: 20 })
          .backgroundColor(this.isDarkMode ? $r('app.color.ohos_id_color_background_secondary_dark') : $r('app.color.ohos_id_color_background_secondary'))
          .borderRadius(25)
          .padding({ left: 20, right: 20 })
          .fontColor(this.isDarkMode ? $r('app.color.ohos_id_color_text_primary_dark') : $r('app.color.ohos_id_color_text_primary'))
          .type(InputType.Password)
          .onChange((value: string) => {
            this.confirmPassword = value;
          })

        // Register button
        Button('注册')
          .width('90%')
          .height(50)
          .margin({ top: 40 })
          .backgroundColor(this.isDarkMode ? $r('app.color.ohos_id_color_background_secondary_dark') : $r('app.color.ohos_id_color_background_secondary'))
          .borderRadius(25)
          .fontColor(this.isDarkMode ? $r('app.color.ohos_id_color_text_primary_dark') : $r('app.color.ohos_id_color_text_primary'))
          .onClick(() => {
            this.handleRegister();
          })
      }
      .width('100%')
      .margin({ top: 20 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(this.isDarkMode ? $r('app.color.ohos_id_color_background_base_dark') : $r('app.color.ohos_id_color_background_base'))
  }
} 