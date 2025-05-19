import router from '@ohos.router';
import common from '@ohos.app.ability.common';
import promptAction from '@ohos.promptAction';
import preferences from '@ohos.data.preferences';
import { ThemeManager } from '../common/ThemeManager';
import { UserManager } from '../common/UserManager';

@Entry
@Component
struct Login {
  @State isDarkMode: boolean = false;
  @State username: string = '';
  @State password: string = '';
  @State rememberAccount: boolean = false;
  private context = getContext(this) as common.UIAbilityContext;
  private themeManager: ThemeManager = ThemeManager.getInstance(this.context);
  private userManager: UserManager = UserManager.getInstance(this.context);
  private readonly PREFERENCES_NAME = 'login_preferences';
  private readonly USERNAME_KEY = 'username';
  private readonly PASSWORD_KEY = 'password';
  private readonly REMEMBER_KEY = 'remember';

  async aboutToAppear() {
    // 初始化主题
    this.isDarkMode = this.themeManager.getIsDarkMode();
    this.themeManager.addListener((isDarkMode: boolean) => {
      this.isDarkMode = isDarkMode;
    });

    // 初始化用户管理器
    try {
      await this.userManager.init();
    } catch {
      promptAction.showToast({ message: '初始化用户管理器失败' });
      return;
    }

    // 加载保存的账号信息
    try {
      const prefs = await preferences.getPreferences(this.context, this.PREFERENCES_NAME);
      this.rememberAccount = await prefs.get(this.REMEMBER_KEY, false) as boolean;
      if (this.rememberAccount) {
        this.username = await prefs.get(this.USERNAME_KEY, '') as string;
        this.password = await prefs.get(this.PASSWORD_KEY, '') as string;
        
        // 如果有保存的账号密码，尝试自动登录
        if (this.username && this.password) {
          try {
            const success = await this.userManager.login(this.username, this.password);
            if (success) {
              promptAction.showToast({ message: '自动登录成功' });
              router.pushUrl({
                url: 'pages/main',
                params: {
                  fromLogin: true
                }
              });
              return;
            }
          } catch {
            console.error('Auto login failed');
          }
        }
      }
    } catch {
      console.error('Failed to load saved account');
    }
  }

  aboutToDisappear() {
    this.themeManager.removeListener();
  }

  async handleLogin() {
    if (!this.username || !this.password) {
      promptAction.showToast({ message: '请输入账号和密码' });
      return;
    }

    try {
      const success = await this.userManager.login(this.username, this.password);
      if (success) {
        // 保存账号信息
        if (this.rememberAccount) {
          const prefs = await preferences.getPreferences(this.context, this.PREFERENCES_NAME);
          await prefs.put(this.USERNAME_KEY, this.username);
          await prefs.put(this.PASSWORD_KEY, this.password);
          await prefs.put(this.REMEMBER_KEY, true);
          await prefs.flush();
        } else {
          // 如果取消记住账号，清除保存的信息
          const prefs = await preferences.getPreferences(this.context, this.PREFERENCES_NAME);
          await prefs.delete(this.USERNAME_KEY);
          await prefs.delete(this.PASSWORD_KEY);
          await prefs.put(this.REMEMBER_KEY, false);
          await prefs.flush();
        }

        promptAction.showToast({ message: '登录成功' });
        router.pushUrl({
          url: 'pages/main',
          params: {
            fromLogin: true
          }
        });
      } else {
        promptAction.showToast({ message: '账号或密码错误' });
      }
    } catch {
      promptAction.showToast({ message: '登录失败，请重试' });
    }
  }

  build() {
    Stack() {
      Column() {
        // Logo and title
        Column() {
          Image($r('app.media.ic_public_text_filled'))
            .width(80)
            .height(80)
            .fillColor(this.isDarkMode ? $r('app.color.ohos_id_color_text_primary_dark') : $r('app.color.ohos_id_color_text_primary'))
            .margin({ bottom: 20 })

          Text('Note')
            .fontSize(32)
            .fontWeight(FontWeight.Bold)
            .fontColor(this.isDarkMode ? $r('app.color.ohos_id_color_text_primary_dark') : $r('app.color.ohos_id_color_text_primary'))
        }
        .width('100%')
        .margin({ top: 80, bottom: 60 })

        // Login form
        Column() {
          // Username input
          TextInput({ text: this.username, placeholder: '请输入账号' })
            .width('90%')
            .height(50)
            .margin({ bottom: 20 })
            .backgroundColor(this.isDarkMode ? $r('app.color.ohos_id_color_background_secondary_dark') : $r('app.color.ohos_id_color_background_secondary'))
            .borderRadius(25)
            .padding({ left: 20, right: 20 })
            .fontColor(this.isDarkMode ? $r('app.color.ohos_id_color_text_primary_dark') : $r('app.color.ohos_id_color_text_primary'))
            .placeholderColor(this.isDarkMode ? $r('app.color.ohos_id_color_text_secondary_dark') : $r('app.color.ohos_id_color_text_secondary'))
            .onChange((value: string) => {
              this.username = value;
            })

          // Password input
          TextInput({ text: this.password, placeholder: '请输入密码' })
            .width('90%')
            .height(50)
            .margin({ bottom: 20 })
            .backgroundColor(this.isDarkMode ? $r('app.color.ohos_id_color_background_secondary_dark') : $r('app.color.ohos_id_color_background_secondary'))
            .borderRadius(25)
            .padding({ left: 20, right: 20 })
            .fontColor(this.isDarkMode ? $r('app.color.ohos_id_color_text_primary_dark') : $r('app.color.ohos_id_color_text_primary'))
            .placeholderColor(this.isDarkMode ? $r('app.color.ohos_id_color_text_secondary_dark') : $r('app.color.ohos_id_color_text_secondary'))
            .type(InputType.Password)
            .onChange((value: string) => {
              this.password = value;
            })

          // Remember account checkbox
          Row() {
            Checkbox()
              .select(this.rememberAccount)
              .onChange((value: boolean) => {
                this.rememberAccount = value;
              })
            Text('记住账号密码')
              .fontSize(14)
              .fontColor(this.isDarkMode ? $r('app.color.ohos_id_color_text_secondary_dark') : $r('app.color.ohos_id_color_text_secondary'))
              .margin({ left: 8 })
          }
          .width('90%')
          .justifyContent(FlexAlign.Start)
          .margin({ bottom: 40 })

          // Login button
          Button('登录')
            .width('90%')
            .height(50)
            .backgroundColor(this.isDarkMode ? $r('app.color.ohos_id_color_background_secondary_dark') : $r('app.color.ohos_id_color_background_secondary'))
            .borderRadius(25)
            .fontColor(this.isDarkMode ? $r('app.color.ohos_id_color_text_primary_dark') : $r('app.color.ohos_id_color_text_primary'))
            .onClick(() => {
              this.handleLogin();
            })

          // Register link
          Text('没有账号？点击注册')
            .fontSize(14)
            .fontColor(this.isDarkMode ? $r('app.color.ohos_id_color_text_secondary_dark') : $r('app.color.ohos_id_color_text_secondary'))
            .margin({ top: 20 })
            .onClick(() => {
              router.pushUrl({ url: 'pages/register' });
            })
        }
        .width('100%')
      }
      .width('100%')
      .height('100%')
      .backgroundColor(this.isDarkMode ? $r('app.color.ohos_id_color_background_base_dark') : $r('app.color.ohos_id_color_background_base'))
    }
  }
} 