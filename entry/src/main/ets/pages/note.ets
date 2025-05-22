import router from '@ohos.router';
import common from '@ohos.app.ability.common';
import { ThemeManager } from '../common/ThemeManager';
import { MarkdownEditor } from '../common/MarkdownEditor';
import { RichTextEditor } from '../common/RichTextEditor';

@Entry
@Component
struct Note {
  @State isDarkMode: boolean = false;
  @State showDirectory: boolean = false;
  @State isMarkdownMode: boolean = true;
  @State showEditorTip: boolean = false;
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

        // 编辑器切换按钮
        Button({ type: ButtonType.Circle }) {
          Text(this.isMarkdownMode ? 'M' : 'T')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor(this.isDarkMode ? $r('app.color.ohos_id_color_text_primary_dark') : $r('app.color.ohos_id_color_text_primary'))
        }
        .width(44)
        .height(44)
        .margin({ left: 12 })
        .backgroundColor(this.isDarkMode ? $r('app.color.ohos_id_color_background_secondary_dark') : $r('app.color.ohos_id_color_background_secondary'))
        .shadow({ radius: 8, color: this.isDarkMode ? $r('app.color.ohos_id_color_shadow_dark') : $r('app.color.ohos_id_color_shadow'), offsetY: 2 })
        .onClick(() => {
          this.isMarkdownMode = !this.isMarkdownMode;
          this.showEditorTip = true;
          // 2秒后自动隐藏提示
          setTimeout(() => {
            this.showEditorTip = false;
          }, 2000);
        })

        // 编辑器切换提示
        if (this.showEditorTip) {
          Text(this.isMarkdownMode ? '已切换到Markdown编辑模式' : '已切换到富文本编辑模式')
            .fontSize(16)
            .fontColor(this.isDarkMode ? $r('app.color.ohos_id_color_text_primary_dark') : $r('app.color.ohos_id_color_text_primary'))
            .margin({ left: 12 })
            .backgroundColor(this.isDarkMode ? $r('app.color.ohos_id_color_background_secondary_dark') : $r('app.color.ohos_id_color_background_secondary'))
            .borderRadius(18)
            .padding({ left: 12, right: 12, top: 8, bottom: 8 })
        }

        Blank()

        // Action buttons
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
      Row() {
        // 左侧AI功能区域
        Column() {
          Button() {
            Row() {
              Image($r('app.media.ic_public_text_filled'))
                .width(20)
                .height(20)
                .fillColor(this.isDarkMode ? $r('app.color.ohos_id_color_text_primary_dark') : $r('app.color.ohos_id_color_text_primary'))
                .margin({ right: 4 })
              Text('AI辅助')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .fontColor(this.isDarkMode ? $r('app.color.ohos_id_color_text_primary_dark') : $r('app.color.ohos_id_color_text_primary'))
            }
          }
          .width(120)
          .height(36)
          .backgroundColor(this.isDarkMode ? $r('app.color.ohos_id_color_background_secondary_dark') : $r('app.color.ohos_id_color_background_secondary'))
          .borderRadius(18)
          .margin({ bottom: 16 })

          Button() {
            Text('文本纠错')
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .fontColor(this.isDarkMode ? $r('app.color.ohos_id_color_text_primary_dark') : $r('app.color.ohos_id_color_text_primary'))
          }
          .width(120)
          .height(40)
          .margin({ bottom: 8 })
          .backgroundColor(this.isDarkMode ? $r('app.color.ohos_id_color_background_secondary_dark') : $r('app.color.ohos_id_color_background_secondary'))
          .borderRadius(20)
          .onClick(() => {
            // Handle text correction
          })

          Button() {
            Text('文本提取')
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .fontColor(this.isDarkMode ? $r('app.color.ohos_id_color_text_primary_dark') : $r('app.color.ohos_id_color_text_primary'))
          }
          .width(120)
          .height(40)
          .margin({ bottom: 8 })
          .backgroundColor(this.isDarkMode ? $r('app.color.ohos_id_color_background_secondary_dark') : $r('app.color.ohos_id_color_background_secondary'))
          .borderRadius(20)
          .onClick(() => {
            // Handle text extraction
          })

          Button() {
            Text('任务摘要')
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .fontColor(this.isDarkMode ? $r('app.color.ohos_id_color_text_primary_dark') : $r('app.color.ohos_id_color_text_primary'))
          }
          .width(120)
          .height(40)
          .margin({ bottom: 8 })
          .backgroundColor(this.isDarkMode ? $r('app.color.ohos_id_color_background_secondary_dark') : $r('app.color.ohos_id_color_background_secondary'))
          .borderRadius(20)
          .onClick(() => {
            // Handle task summary
          })

          Button() {
            Text('修改标签')
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .fontColor(this.isDarkMode ? $r('app.color.ohos_id_color_text_primary_dark') : $r('app.color.ohos_id_color_text_primary'))
          }
          .width(120)
          .height(40)
          .margin({ bottom: 8 })
          .backgroundColor(this.isDarkMode ? $r('app.color.ohos_id_color_background_secondary_dark') : $r('app.color.ohos_id_color_background_secondary'))
          .borderRadius(20)
          .onClick(() => {
            // Handle tag modification
          })

          Button() {
            Text('选择分类')
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .fontColor(this.isDarkMode ? $r('app.color.ohos_id_color_text_primary_dark') : $r('app.color.ohos_id_color_text_primary'))
          }
          .width(120)
          .height(40)
          .margin({ bottom: 8 })
          .backgroundColor(this.isDarkMode ? $r('app.color.ohos_id_color_background_secondary_dark') : $r('app.color.ohos_id_color_background_secondary'))
          .borderRadius(20)
          .onClick(() => {
            // Handle category selection
          })

          Blank()
            .layoutWeight(1)

          Button() {
            Row() {
              Image($r('app.media.ic_public_text_filled'))
                .width(20)
                .height(20)
                .fillColor(this.isDarkMode ? $r('app.color.ohos_id_color_text_primary_dark') : $r('app.color.ohos_id_color_text_primary'))
                .margin({ right: 4 })
              Text('目录')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .fontColor(this.isDarkMode ? $r('app.color.ohos_id_color_text_primary_dark') : $r('app.color.ohos_id_color_text_primary'))
            }
          }
          .width(120)
          .height(36)
          .backgroundColor(this.isDarkMode ? $r('app.color.ohos_id_color_background_secondary_dark') : $r('app.color.ohos_id_color_background_secondary'))
          .borderRadius(18)
          .margin({ bottom: 16 })
          .onClick(() => {
            this.showDirectory = !this.showDirectory;
          })
        }
        .width(160)
        .height('100%')
        .padding(16)
        .backgroundColor(this.isDarkMode ? $r('app.color.ohos_id_color_background_secondary_dark') : $r('app.color.ohos_id_color_background_secondary'))
        .border({
          width: { right: 2 },
          color: this.isDarkMode ? $r('app.color.ohos_id_color_divider_dark') : $r('app.color.ohos_id_color_divider'),
          style: BorderStyle.Solid
        })

        // 编辑区域
        Column() {
          // 编辑器和目录面板
          Row() {
            if (this.isMarkdownMode) {
              MarkdownEditor({
                isDarkMode: this.isDarkMode,
                isMarkdownMode: $isMarkdownMode
              })
              .width(this.showDirectory ? 'calc(100% - 200px)' : '100%')
              .height('100%')
            } else {
              RichTextEditor({
                isDarkMode: this.isDarkMode,
                isMarkdownMode: $isMarkdownMode
              })
              .width(this.showDirectory ? 'calc(100% - 200px)' : '100%')
              .height('100%')
            }

            // 目录面板
            if (this.showDirectory) {
              Column() {
                // 目录内容占位
                Text('')
                  .fontSize(16)
                  .fontColor(this.isDarkMode ? $r('app.color.ohos_id_color_text_primary_dark') : $r('app.color.ohos_id_color_text_primary'))
              }
              .width(200)
              .height('100%')
              .padding(16)
              .backgroundColor(this.isDarkMode ? $r('app.color.ohos_id_color_background_secondary_dark') : $r('app.color.ohos_id_color_background_secondary'))
              .border({
                width: { left: 1 },
                color: this.isDarkMode ? $r('app.color.ohos_id_color_divider_dark') : $r('app.color.ohos_id_color_divider'),
                style: BorderStyle.Solid
              })
            }
          }
          .width('100%')
          .height('100%')
        }
        .layoutWeight(1)
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