import common from '@ohos.app.ability.common';
import { fileIo as fs } from '@kit.CoreFileKit';
import { LvMarkdownIn, LMICallBack } from '@luvi/lv-markdown-in';

@Component
export struct MarkdownEditor {
  @Prop isDarkMode: boolean;
  @State content: string = '';
  @Link isMarkdownMode: boolean;
  @State showPreview: boolean = false;
  private context = getContext(this) as common.UIAbilityContext;

  build() {
    Row() {
      // 左侧空白区域
      Blank()
        .width('10%')
      
      // 中间编辑区域
      Column() {
        if (!this.showPreview) {
          TextArea({ text: this.content, placeholder: '开始输入M...' })
            .width('100%')
            .height('100%')
            .backgroundColor('transparent')
            .fontColor(this.isDarkMode ? $r('app.color.ohos_id_color_text_primary_dark') : $r('app.color.ohos_id_color_text_primary'))
            .fontSize(18)
            .padding(16)
            .onChange((value: string) => {
              this.content = value;
            })
        } else {
          LvMarkdownIn({
            text: this.content,
            loadMode: "text",
            loadCallBack: {
              success(r: LMICallBack) {
                console.info("Markdown preview success: " + r.code, r.message)
              },
              fail(r: LMICallBack) {
                console.error("Markdown preview failed: " + r.code, r.message)
              }
            }
          })
            .width('100%')
            .height('100%')
            .backgroundColor(this.isDarkMode ? $r('app.color.ohos_id_color_background_base_dark') : $r('app.color.ohos_id_color_background_base'))
        }
      }
      .width('70%')
      .height('100%')
      .backgroundColor(this.isDarkMode ? $r('app.color.ohos_id_color_background_base_dark') : $r('app.color.ohos_id_color_background_base'))

      // 右侧按钮区域
      Column() {
        Button('预览')
          .width('80%')
          .margin({ top: 10 })
          .onClick(() => {
            this.showPreview = !this.showPreview;
          })
      }
      .width('20%')
      .height('100%')
      .backgroundColor(this.isDarkMode ? $r('app.color.ohos_id_color_background_base_dark') : $r('app.color.ohos_id_color_background_base'))
      .alignItems(HorizontalAlign.Center)
    }
    .width('100%')
    .height('100%')
  }
}