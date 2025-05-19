import router from '@ohos.router';
import common from '@ohos.app.ability.common';
import { ThemeManager } from '../common/ThemeManager';
import promptAction from '@ohos.promptAction';
import preferences from '@ohos.data.preferences';

@Entry
@Component
struct Setting {
  @State isDarkMode: boolean = false;
  @State isDarkModeEnabled: boolean = false;
  @State showVersionDialog: boolean = false;
  @State showThemeDialog: boolean = false;
  private context = getContext(this) as common.UIAbilityContext;
  private themeManager: ThemeManager = ThemeManager.getInstance(this.context);
  private readonly PREFERENCES_NAME = 'login_preferences';
  private readonly USERNAME_KEY = 'username';
  private readonly PASSWORD_KEY = 'password';
  private readonly REMEMBER_KEY = 'remember';

  aboutToAppear() {
    this.themeManager.init();
    this.isDarkMode = this.themeManager.getIsDarkMode();
    this.isDarkModeEnabled = this.isDarkMode;
    this.themeManager.addListener((isDarkMode: boolean) => {
      this.isDarkMode = isDarkMode;
      this.isDarkModeEnabled = isDarkMode;
    });
  }

  aboutToDisappear() {
    this.themeManager.removeListener();
  }

  async handleLogout() {
    try {
      // 清除保存的账号密码信息
      const prefs = await preferences.getPreferences(this.context, this.PREFERENCES_NAME);
      await prefs.delete(this.USERNAME_KEY);
      await prefs.delete(this.PASSWORD_KEY);
      await prefs.put(this.REMEMBER_KEY, false);
      await prefs.flush();

      // 跳转到登录页面
      router.replaceUrl({ url: 'pages/login' });
    } catch {
      promptAction.showToast({ message: '登出失败，请重试' });
    }
  }

  build() {
    Stack() {
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

          Text('设置')
            .fontSize(28)
            .fontWeight(FontWeight.Bold)
            .margin({ left: 20 })
            .fontColor(this.isDarkMode ? $r('app.color.ohos_id_color_text_primary_dark') : $r('app.color.ohos_id_color_text_primary'))
        }
        .width('100%')
        .height(64)
        .backgroundColor(this.isDarkMode ? $r('app.color.ohos_id_color_background_primary_dark') : $r('app.color.ohos_id_color_background_primary'))
        .shadow({ radius: 8, color: this.isDarkMode ? $r('app.color.ohos_id_color_shadow_dark') : $r('app.color.ohos_id_color_shadow'), offsetY: 2 })

        // Settings content
        Column() {
          // Theme Settings
          Row() {
            Row() {
              Image($r('app.media.ic_public_themes_filled'))
                .width(24)
                .height(24)
                .fillColor(this.isDarkMode ? $r('app.color.ohos_id_color_text_primary_dark') : $r('app.color.ohos_id_color_text_primary'))
                .margin({ right: 12 })
              Text('主题设置')
                .fontSize(16)
                .fontColor(this.isDarkMode ? $r('app.color.ohos_id_color_text_primary_dark') : $r('app.color.ohos_id_color_text_primary'))
            }
            .layoutWeight(1)

            Image($r('app.media.ic_public_arrow_right'))
              .width(20)
              .height(20)
              .fillColor(this.isDarkMode ? $r('app.color.ohos_id_color_text_secondary_dark') : $r('app.color.ohos_id_color_text_secondary'))
          }
          .width('100%')
          .height(56)
          .padding({ left: 20, right: 20 })
          .backgroundColor(this.isDarkMode ? $r('app.color.ohos_id_color_background_primary_dark') : $r('app.color.ohos_id_color_background_primary'))
          .onClick(() => {
            this.showThemeDialog = true;
          })

          Divider()
            .color(this.isDarkMode ? $r('app.color.ohos_id_color_divider_dark') : $r('app.color.ohos_id_color_divider'))
            .height(1)

          // About Us
          Row() {
            Row() {
              Image($r('app.media.ic_public_security_filled'))
                .width(24)
                .height(24)
                .fillColor(this.isDarkMode ? $r('app.color.ohos_id_color_text_primary_dark') : $r('app.color.ohos_id_color_text_primary'))
                .margin({ right: 12 })
              Text('关于我们')
                .fontSize(16)
                .fontColor(this.isDarkMode ? $r('app.color.ohos_id_color_text_primary_dark') : $r('app.color.ohos_id_color_text_primary'))
            }
            .layoutWeight(1)

            Image($r('app.media.ic_public_arrow_right'))
              .width(20)
              .height(20)
              .fillColor(this.isDarkMode ? $r('app.color.ohos_id_color_text_secondary_dark') : $r('app.color.ohos_id_color_text_secondary'))
          }
          .width('100%')
          .height(56)
          .padding({ left: 20, right: 20 })
          .backgroundColor(this.isDarkMode ? $r('app.color.ohos_id_color_background_primary_dark') : $r('app.color.ohos_id_color_background_primary'))
          .onClick(() => {
            this.showVersionDialog = true;
          })

          Divider()
            .color(this.isDarkMode ? $r('app.color.ohos_id_color_divider_dark') : $r('app.color.ohos_id_color_divider'))
            .height(1)

          // User Manual
          Row() {
            Row() {
              Image($r('app.media.ic_public_search_filled'))
                .width(24)
                .height(24)
                .fillColor(this.isDarkMode ? $r('app.color.ohos_id_color_text_primary_dark') : $r('app.color.ohos_id_color_text_primary'))
                .margin({ right: 12 })
              Text('使用手册')
                .fontSize(16)
                .fontColor(this.isDarkMode ? $r('app.color.ohos_id_color_text_primary_dark') : $r('app.color.ohos_id_color_text_primary'))
            }
            .layoutWeight(1)

            Image($r('app.media.ic_public_arrow_right'))
              .width(20)
              .height(20)
              .fillColor(this.isDarkMode ? $r('app.color.ohos_id_color_text_secondary_dark') : $r('app.color.ohos_id_color_text_secondary'))
          }
          .width('100%')
          .height(56)
          .padding({ left: 20, right: 20 })
          .backgroundColor(this.isDarkMode ? $r('app.color.ohos_id_color_background_primary_dark') : $r('app.color.ohos_id_color_background_primary'))
          .onClick(() => {
            // Handle user manual click
          })

          Divider()
            .color(this.isDarkMode ? $r('app.color.ohos_id_color_divider_dark') : $r('app.color.ohos_id_color_divider'))
            .height(1)

          // Logout
          Row() {
            Row() {
              Image($r('app.media.ic_public_unlock'))
                .width(24)
                .height(24)
                .fillColor($r('app.color.ohos_id_color_error'))
                .margin({ right: 12 })
              Text('登出')
                .fontSize(16)
                .fontColor($r('app.color.ohos_id_color_error'))
            }
            .layoutWeight(1)
          }
          .width('100%')
          .height(56)
          .padding({ left: 20, right: 20 })
          .backgroundColor(this.isDarkMode ? $r('app.color.ohos_id_color_background_primary_dark') : $r('app.color.ohos_id_color_background_primary'))
          .onClick(() => {
            promptAction.showDialog({
              title: '确认登出',
              message: '确认登出？你的笔记会保存，但是你无法在别的账号查看本账号的笔记。',
              buttons: [
                {
                  text: '取消',
                  color: this.isDarkMode ? $r('app.color.ohos_id_color_text_primary_dark') : $r('app.color.ohos_id_color_text_primary')
                },
                {
                  text: '确认',
                  color: this.isDarkMode ? $r('app.color.ohos_id_color_text_primary_dark') : $r('app.color.ohos_id_color_text_primary')
                }
              ]
            }).then((result) => {
              if (result.index === 1) { // 确认按钮
                this.handleLogout();
              }
            });
          })
        }
        .width('100%')
        .margin({ top: 12 })
        .backgroundColor(this.isDarkMode ? $r('app.color.ohos_id_color_background_base_dark') : $r('app.color.ohos_id_color_background_base'))
        .borderRadius(12)
      }
      .width('100%')
      .height('100%')
      .backgroundColor(this.isDarkMode ? $r('app.color.ohos_id_color_background_base_dark') : $r('app.color.ohos_id_color_background_base'))

      // Theme Selection Dialog
      if (this.showThemeDialog) {
        Column() {
          Column() {
            Text('选择主题')
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .margin({ top: 20, bottom: 20 })
              .fontColor(this.isDarkMode ? $r('app.color.ohos_id_color_text_primary_dark') : $r('app.color.ohos_id_color_text_primary'))

            Row() {
              Column() {
                Image($r('app.media.ic_public_themes_filled'))
                  .width(32)
                  .height(32)
                  .fillColor($r('app.color.ohos_id_color_text_primary'))
                  .margin({ bottom: 8 })
                Text('浅色')
                  .fontSize(16)
                  .fontColor($r('app.color.ohos_id_color_text_primary'))
              }
              .width(100)
              .height(100)
              .backgroundColor($r('app.color.ohos_id_color_background_primary'))
              .borderRadius(12)
              .onClick(() => {
                this.themeManager.setIsDarkMode(false);
                this.showThemeDialog = false;
              })

              Column() {
                Image($r('app.media.ic_public_themes_filled'))
                  .width(32)
                  .height(32)
                  .fillColor($r('app.color.ohos_id_color_text_primary_dark'))
                  .margin({ bottom: 8 })
                Text('深色')
                  .fontSize(16)
                  .fontColor($r('app.color.ohos_id_color_text_primary_dark'))
              }
              .width(100)
              .height(100)
              .backgroundColor($r('app.color.ohos_id_color_background_primary_dark'))
              .borderRadius(12)
              .margin({ left: 20 })
              .onClick(() => {
                this.themeManager.setIsDarkMode(true);
                this.showThemeDialog = false;
              })
            }
            .margin({ bottom: 20 })
          }
          .width('90%')
          .backgroundColor(this.isDarkMode ? $r('app.color.ohos_id_color_background_primary_dark') : $r('app.color.ohos_id_color_background_primary'))
          .borderRadius(12)
        }
        .width('100%')
        .height('100%')
        .backgroundColor(this.isDarkMode ? '#00000080' : '#00000040')
        .position({ x: 0, y: 0 })
        .onClick(() => {
          this.showThemeDialog = false
        })
      }

      // Version Info Dialog
      if (this.showVersionDialog) {
        Column() {
          Column() {
            Text('版本信息')
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .margin({ top: 20, bottom: 20 })
              .fontColor(this.isDarkMode ? $r('app.color.ohos_id_color_text_primary_dark') : $r('app.color.ohos_id_color_text_primary'))

            Column() {
              Text('版本：2.1')
                .fontSize(16)
                .margin({ bottom: 12 })
                .fontColor(this.isDarkMode ? $r('app.color.ohos_id_color_text_primary_dark') : $r('app.color.ohos_id_color_text_primary'))
              
              Text('更新时间：2025/5/19')
                .fontSize(16)
                .margin({ bottom: 12 })
                .fontColor(this.isDarkMode ? $r('app.color.ohos_id_color_text_primary_dark') : $r('app.color.ohos_id_color_text_primary'))
              
              Text('更新人：龙金伟')
                .fontSize(16)
                .margin({ bottom: 12 })
                .fontColor(this.isDarkMode ? $r('app.color.ohos_id_color_text_primary_dark') : $r('app.color.ohos_id_color_text_primary'))
              
              Text('新增内容：基于百度云的NLP处理功能')
                .fontSize(16)
                .margin({ bottom: 12 })
                .fontColor(this.isDarkMode ? $r('app.color.ohos_id_color_text_primary_dark') : $r('app.color.ohos_id_color_text_primary'))
              
              Text('修改内容：语音识别和图片插入功能')
                .fontSize(16)
                .margin({ bottom: 12 })
                .fontColor(this.isDarkMode ? $r('app.color.ohos_id_color_text_primary_dark') : $r('app.color.ohos_id_color_text_primary'))
              
              Text('功能预计回归时间：未知')
                .fontSize(16)
                .margin({ bottom: 20 })
                .fontColor(this.isDarkMode ? $r('app.color.ohos_id_color_text_primary_dark') : $r('app.color.ohos_id_color_text_primary'))
            }
            .padding({ left: 20, right: 20 })
          }
          .width('90%')
          .backgroundColor(this.isDarkMode ? $r('app.color.ohos_id_color_background_primary_dark') : $r('app.color.ohos_id_color_background_primary'))
          .borderRadius(12)
        }
        .width('100%')
        .height('100%')
        .backgroundColor(this.isDarkMode ? '#00000080' : '#00000040')
        .position({ x: 0, y: 0 })
        .onClick(() => {
          this.showVersionDialog = false
        })
      }
    }
  }
}
