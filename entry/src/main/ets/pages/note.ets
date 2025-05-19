import router from '@ohos.router';
import common from '@ohos.app.ability.common';
import promptAction from '@ohos.promptAction';
import { ThemeManager } from '../common/ThemeManager';

@Entry
@Component
struct Note {
  @State isDarkMode: boolean = false;
  @State showAIMenu: boolean = false;
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
    Stack() {
      Column() {
        // Top bar with back button and action buttons
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

          Text('新建笔记')
            .fontSize(28)
            .fontWeight(FontWeight.Bold)
            .margin({ left: 20 })
            .fontColor(this.isDarkMode ? $r('app.color.ohos_id_color_text_primary_dark') : $r('app.color.ohos_id_color_text_primary'))

          Blank()

          // Action buttons
          Button({ type: ButtonType.Circle }) {
            Image($r('app.media.ic_public_search_filled'))
              .width(24)
              .height(24)
              .fillColor(this.isDarkMode ? $r('app.color.ohos_id_color_text_primary_dark') : $r('app.color.ohos_id_color_text_primary'))
          }
          .width(44)
          .height(44)
          .margin({ right: 12 })
          .backgroundColor(this.isDarkMode ? $r('app.color.ohos_id_color_background_secondary_dark') : $r('app.color.ohos_id_color_background_secondary'))
          .shadow({ radius: 8, color: this.isDarkMode ? $r('app.color.ohos_id_color_shadow_dark') : $r('app.color.ohos_id_color_shadow'), offsetY: 2 })
          .onClick(() => {
            // Handle preview click
          })

          Button({ type: ButtonType.Circle }) {
            Image($r('app.media.ic_public_view_list_filled'))
              .width(24)
              .height(24)
              .fillColor(this.isDarkMode ? $r('app.color.ohos_id_color_text_primary_dark') : $r('app.color.ohos_id_color_text_primary'))
          }
          .width(44)
          .height(44)
          .margin({ right: 12 })
          .backgroundColor(this.isDarkMode ? $r('app.color.ohos_id_color_background_secondary_dark') : $r('app.color.ohos_id_color_background_secondary'))
          .shadow({ radius: 8, color: this.isDarkMode ? $r('app.color.ohos_id_color_shadow_dark') : $r('app.color.ohos_id_color_shadow'), offsetY: 2 })
          .onClick(() => {
            // Handle set as todo click
          })

          Button({ type: ButtonType.Circle }) {
            Image($r('app.media.ic_public_save'))
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
            // Handle save click
          })
        }
        .width('100%')
        .height(64)
        .backgroundColor(this.isDarkMode ? $r('app.color.ohos_id_color_background_primary_dark') : $r('app.color.ohos_id_color_background_primary'))
        .shadow({ radius: 8, color: this.isDarkMode ? $r('app.color.ohos_id_color_shadow_dark') : $r('app.color.ohos_id_color_shadow'), offsetY: 2 })

        // Main content
        Row() {
          // AI Button and Menu
          Column() {
            Button() {
              Row() {
                Image($r('app.media.ic_public_text_filled'))
                  .width(24)
                  .height(24)
                  .fillColor(this.isDarkMode ? $r('app.color.ohos_id_color_text_primary_dark') : $r('app.color.ohos_id_color_text_primary'))
                  .margin({ right: 8 })
                Text('AI笔记')
                  .fontSize(16)
                  .fontColor(this.isDarkMode ? $r('app.color.ohos_id_color_text_primary_dark') : $r('app.color.ohos_id_color_text_primary'))
              }
            }
            .width(120)
            .height(48)
            .margin({ top: 20 })
            .backgroundColor(this.isDarkMode ? $r('app.color.ohos_id_color_background_secondary_dark') : $r('app.color.ohos_id_color_background_secondary'))
            .borderRadius(24)
            .shadow({ radius: 8, color: this.isDarkMode ? $r('app.color.ohos_id_color_shadow_dark') : $r('app.color.ohos_id_color_shadow'), offsetY: 2 })
            .onClick(() => {
              this.showAIMenu = !this.showAIMenu;
            })

            if (this.showAIMenu) {
              Column() {
                Button('文本纠错')
                  .width(120)
                  .height(40)
                  .margin({ top: 8 })
                  .backgroundColor(this.isDarkMode ? $r('app.color.ohos_id_color_background_secondary_dark') : $r('app.color.ohos_id_color_background_secondary'))
                  .borderRadius(20)
                  .onClick(() => {
                    // Handle text correction
                  })

                Button('文本提取')
                  .width(120)
                  .height(40)
                  .margin({ top: 8 })
                  .backgroundColor(this.isDarkMode ? $r('app.color.ohos_id_color_background_secondary_dark') : $r('app.color.ohos_id_color_background_secondary'))
                  .borderRadius(20)
                  .onClick(() => {
                    // Handle text extraction
                  })

                Button('任务摘要')
                  .width(120)
                  .height(40)
                  .margin({ top: 8 })
                  .backgroundColor(this.isDarkMode ? $r('app.color.ohos_id_color_background_secondary_dark') : $r('app.color.ohos_id_color_background_secondary'))
                  .borderRadius(20)
                  .onClick(() => {
                    // Handle task summary
                  })

                Button('修改标签')
                  .width(120)
                  .height(40)
                  .margin({ top: 8 })
                  .backgroundColor(this.isDarkMode ? $r('app.color.ohos_id_color_background_secondary_dark') : $r('app.color.ohos_id_color_background_secondary'))
                  .borderRadius(20)
                  .onClick(() => {
                    // Handle tag modification
                  })

                Button('选择分类')
                  .width(120)
                  .height(40)
                  .margin({ top: 8 })
                  .backgroundColor(this.isDarkMode ? $r('app.color.ohos_id_color_background_secondary_dark') : $r('app.color.ohos_id_color_background_secondary'))
                  .borderRadius(20)
                  .onClick(() => {
                    // Handle category selection
                  })
              }
              .margin({ top: 12 })
            }
          }
          .width(160)
          .height('100%')
          .backgroundColor(this.isDarkMode ? $r('app.color.ohos_id_color_background_primary_dark') : $r('app.color.ohos_id_color_background_primary'))
          .border({ width: { right: 1 }, color: this.isDarkMode ? $r('app.color.ohos_id_color_divider_dark') : $r('app.color.ohos_id_color_divider') })

          // Note content area
          Column() {
            // Note content will be added later
          }
          .width('100%')
          .height('100%')
          .backgroundColor(this.isDarkMode ? $r('app.color.ohos_id_color_background_base_dark') : $r('app.color.ohos_id_color_background_base'))
        }
        .width('100%')
        .height('100%')
      }
      .width('100%')
      .height('100%')
      .backgroundColor(this.isDarkMode ? $r('app.color.ohos_id_color_background_base_dark') : $r('app.color.ohos_id_color_background_base'))
    }
  }
}
