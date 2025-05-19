import router from '@ohos.router';
import common from '@ohos.app.ability.common';
import promptAction from '@ohos.promptAction';
import { ThemeManager } from '../common/ThemeManager';

@Entry
@Component
struct Main {
  @State isDarkMode: boolean = false;
  private context = getContext(this) as common.UIAbilityContext;
  private themeManager: ThemeManager = ThemeManager.getInstance(this.context);

  aboutToAppear() {
    // 检查是否从登录页面来
    const params = router.getParams();
    const fromLogin = params ? (params as Record<string, boolean>).fromLogin : false;
    if (!fromLogin) {
      // 如果不是从登录页面来，返回登录页面
      router.replaceUrl({ url: 'pages/login' });
      return;
    }

    // 初始化主题
    this.isDarkMode = this.themeManager.getIsDarkMode();
    this.themeManager.addListener((isDarkMode: boolean) => {
      this.isDarkMode = isDarkMode;
    });
  }

  aboutToDisappear() {
    this.themeManager.removeListener();
  }

  build() {
    Stack() {
      Column() {
        // Top bar with logo and settings
        Row() {
          Image($r('app.media.ic_public_text_filled'))
            .width(32)
            .height(32)
            .fillColor(this.isDarkMode ? $r('app.color.ohos_id_color_text_primary_dark') : $r('app.color.ohos_id_color_text_primary'))
            .margin({ left: 20 })

          Text('Note')
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
            .margin({ left: 12 })
            .fontColor(this.isDarkMode ? $r('app.color.ohos_id_color_text_primary_dark') : $r('app.color.ohos_id_color_text_primary'))

          Blank()

          Button({ type: ButtonType.Circle }) {
            Image($r('app.media.ic_public_settings'))
              .width(24)
              .height(24)
              .fillColor(this.isDarkMode ? $r('app.color.ohos_id_color_text_primary_dark') : $r('app.color.ohos_id_color_text_primary'))
          }
          .width(44)
          .height(44)
          .margin({ right: 20 })
          .backgroundColor(this.isDarkMode ? $r('app.color.ohos_id_color_background_secondary_dark') : $r('app.color.ohos_id_color_background_secondary'))
          .shadow({ radius: 8, color: this.isDarkMode ? $r('app.color.ohos_id_color_shadow_dark') : $r('app.color.ohos_id_color_shadow'), offsetY: 2 })
          .onClick(() => {
            router.pushUrl({ url: 'pages/setting' })
          })
        }
        .width('100%')
        .height(64)
        .backgroundColor(this.isDarkMode ? $r('app.color.ohos_id_color_background_primary_dark') : $r('app.color.ohos_id_color_background_primary'))
        .shadow({ radius: 8, color: this.isDarkMode ? $r('app.color.ohos_id_color_shadow_dark') : $r('app.color.ohos_id_color_shadow'), offsetY: 2 })

        // Main content
        Column() {
          // Todo List Button
          Button() {
            Row() {
              Image($r('app.media.ic_public_view_list_filled'))
                .width(24)
                .height(24)
                .fillColor($r('app.color.ohos_id_color_text_primary'))
                .margin({ right: 8 })
              Text('待办事项')
                .fontSize(16)
                .fontColor($r('app.color.ohos_id_color_text_primary'))
            }
          }
          .width(160)
          .height(48)
          .margin({ bottom: 16 })
          .backgroundColor(this.isDarkMode ? $r('app.color.ohos_id_color_background_secondary_dark') : $r('app.color.ohos_id_color_background_secondary'))
          .borderRadius(24)
          .shadow({ radius: 8, color: this.isDarkMode ? $r('app.color.ohos_id_color_shadow_dark') : $r('app.color.ohos_id_color_shadow'), offsetY: 2 })
          .onClick(() => {
            router.pushUrl({ url: 'pages/todo' })
          })

          // New Note Button
          Button() {
            Row() {
              Image($r('app.media.ic_public_add'))
                .width(24)
                .height(24)
                .fillColor($r('app.color.ohos_id_color_text_primary'))
                .margin({ right: 8 })
              Text('新建笔记')
                .fontSize(16)
                .fontColor($r('app.color.ohos_id_color_text_primary'))
            }
          }
          .width(160)
          .height(48)
          .backgroundColor(this.isDarkMode ? $r('app.color.ohos_id_color_background_secondary_dark') : $r('app.color.ohos_id_color_background_secondary'))
          .borderRadius(24)
          .shadow({ radius: 8, color: this.isDarkMode ? $r('app.color.ohos_id_color_shadow_dark') : $r('app.color.ohos_id_color_shadow'), offsetY: 2 })
          .onClick(() => {
            router.pushUrl({ url: 'pages/note' })
          })
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.End)
        .alignItems(HorizontalAlign.End)
        .padding({ right: 20, bottom: 40 })
        .backgroundColor(this.isDarkMode ? $r('app.color.ohos_id_color_background_base_dark') : $r('app.color.ohos_id_color_background_base'))
      }
      .width('100%')
      .height('100%')
    }
  }
}
