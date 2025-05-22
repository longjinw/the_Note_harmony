import common from '@ohos.app.ability.common';
import { fileIo as fs } from '@kit.CoreFileKit';

@Component
export struct MarkdownEditor {
  @Prop isDarkMode: boolean;
  @State content: string = '';
  @Link isMarkdownMode: boolean;
  private context = getContext(this) as common.UIAbilityContext;

  build() {
    Column() {
      // 编辑区域
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
    }
    .width('100%')
    .height('100%')
    .backgroundColor('white')
  }
}