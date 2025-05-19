import router from '@ohos.router';
import common from '@ohos.app.ability.common';
import promptAction from '@ohos.promptAction';
import { ThemeManager } from '../common/ThemeManager';

@Entry
@Component
struct Todo {
  @State isDarkMode: boolean = false;
  private context = getContext(this) as common.UIAbilityContext;
  private themeManager: ThemeManager = ThemeManager.getInstance(this.context);

  aboutToAppear() {
    this.themeManager.init();
    this.isDarkMode = this.themeManager.getIsDarkMode();
    this.themeManager.addListener((isDarkMode: boolean) => {
      this.isDarkMode = isDarkMode;
    });
  }

  aboutToDisappear() {
    this.themeManager.removeListener();
  }

  build() {
    Row() {
      // Main content area (5/6 width)
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

          Text('待办事项')
            .fontSize(28)
            .fontWeight(FontWeight.Bold)
            .margin({ left: 20 })
            .fontColor(this.isDarkMode ? $r('app.color.ohos_id_color_text_primary_dark') : $r('app.color.ohos_id_color_text_primary'))
        }
        .width('100%')
        .height(64)
        .backgroundColor(this.isDarkMode ? $r('app.color.ohos_id_color_background_primary_dark') : $r('app.color.ohos_id_color_background_primary'))
        .shadow({ radius: 8, color: this.isDarkMode ? $r('app.color.ohos_id_color_shadow_dark') : $r('app.color.ohos_id_color_shadow'), offsetY: 2 })

        // Todo list content
        Column() {
          // Content will be added later
        }
        .width('100%')
        .height('100%')
        .backgroundColor(this.isDarkMode ? $r('app.color.ohos_id_color_background_base_dark') : $r('app.color.ohos_id_color_background_base'))
      }
      .width('83.33%') // 5/6 of the screen width
      .height('100%')

      // History section (1/6 width)
      Column() {
        Text('历史待办')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 20, bottom: 20 })
          .fontColor(this.isDarkMode ? $r('app.color.ohos_id_color_text_primary_dark') : $r('app.color.ohos_id_color_text_primary'))

        // History content will be added later
      }
      .width('16.67%') // 1/6 of the screen width
      .height('100%')
      .backgroundColor(this.isDarkMode ? $r('app.color.ohos_id_color_background_primary_dark') : $r('app.color.ohos_id_color_background_primary'))
      .border({ width: { left: 1 }, color: this.isDarkMode ? $r('app.color.ohos_id_color_divider_dark') : $r('app.color.ohos_id_color_divider') })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(this.isDarkMode ? $r('app.color.ohos_id_color_background_base_dark') : $r('app.color.ohos_id_color_background_base'))
  }
}
