import router from '@ohos.router';
import common from '@ohos.app.ability.common';
import { ThemeManager } from '../common/ThemeManager';
import { MarkdownEditor } from '../common/MarkdownEditor';

@Entry
@Component
struct Note {
  @State isDarkMode: boolean = false;
  @State isPreviewMode: boolean = false;
  private context = getContext(this) as common.UIAbilityContext;
  private themeManager: ThemeManager = ThemeManager.getInstance(this.context);
  private readonly TOP_BAR_HEIGHT: number = 64;

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
          Image($r('app.media.ic_public_text_filled'))
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
          this.isPreviewMode = !this.isPreviewMode;
        })

        Button({ type: ButtonType.Circle }) {
          Image($r('app.media.ic_public_save_filled'))
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
          // TODO: 实现保存功能
        })
      }
      .width('100%')
      .height(this.TOP_BAR_HEIGHT)
      .backgroundColor(this.isDarkMode ? $r('app.color.ohos_id_color_background_primary_dark') : $r('app.color.ohos_id_color_background_primary'))
      .shadow({ radius: 8, color: this.isDarkMode ? $r('app.color.ohos_id_color_shadow_dark') : $r('app.color.ohos_id_color_shadow'), offsetY: 2 })

      // Main content
      Column() {
        MarkdownEditor({
          isDarkMode: this.isDarkMode,
          isPreviewMode: $isPreviewMode
        })
      }
      .width('100%')
      .height('100%')
      .backgroundColor(this.isDarkMode ? $r('app.color.ohos_id_color_background_base_dark') : $r('app.color.ohos_id_color_background_base'))
    }
    .width('100%')
    .height('100%')
    .backgroundColor(this.isDarkMode ? $r('app.color.ohos_id_color_background_base_dark') : $r('app.color.ohos_id_color_background_base'))
  }
}
