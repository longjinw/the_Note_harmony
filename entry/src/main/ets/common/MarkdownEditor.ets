import common from '@ohos.app.ability.common';
import { lvMarkdownIn, LMICallBack, mdRegister } from '@luvi/lv-markdown-in';

@Component
export struct MarkdownEditor {
  @Link isPreviewMode: boolean;
  @Prop isDarkMode: boolean;
  @State content: string = '';
  @State parsedContent: string = '';

  aboutToAppear() {
    // 注册超链接点击回调
    mdRegister.HandleHyperlink = (url: string) => {
      console.log("拦截跳转 > " + url);
      return false;
    }

    // 暂时禁用图片处理
    mdRegister.HandleImage = (url: string) => {
      console.log("图片处理已禁用 > " + url);
      return true;
    }
  }

  private parseMarkdown(): void {
    if (!this.content || this.content.trim() === '') {
      this.parsedContent = '';
      return;
    }

    try {
      lvMarkdownIn({
        text: this.content,
        loadCallBack: {
          success: (r: LMICallBack) => {
            if (r && r.message) {
              this.parsedContent = r.message;
            }
          },
          fail: (r: LMICallBack) => {
            console.error("解析失败:", r.message);
            this.parsedContent = '';
          }
        }
      });
    } catch (error) {
      console.error('解析错误:', error);
      this.parsedContent = '';
    }
  }

  build() {
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

      // 编辑和预览区域
      Row() {
        // 编辑区域
        Column() {
          TextArea({ text: this.content, placeholder: '开始输入...' })
            .width('100%')
            .height('100%')
            .backgroundColor('transparent')
            .fontColor(this.isDarkMode ? $r('app.color.ohos_id_color_text_primary_dark') : $r('app.color.ohos_id_color_text_primary'))
            .fontSize(18)
            .padding(16)
            .onChange((value: string) => {
              this.content = value;
              this.parseMarkdown();
            })
        }
        .width(this.isPreviewMode ? '50%' : '100%')
        .height('100%')
        .backgroundColor(this.isDarkMode ? $r('app.color.ohos_id_color_background_base_dark') : $r('app.color.ohos_id_color_background_base'))

        // 预览区域
        if (this.isPreviewMode) {
          Column() {
            Scroll() {
              Text(this.parsedContent || '暂无预览内容')
                .width('100%')
                .fontSize(18)
                .padding(16)
                .fontColor(this.isDarkMode ? $r('app.color.ohos_id_color_text_primary_dark') : $r('app.color.ohos_id_color_text_primary'))
                .textAlign(TextAlign.Start)
                .lineHeight(28)
            }
            .width('100%')
            .height('100%')
          }
          .width('50%')
          .height('100%')
          .backgroundColor(this.isDarkMode ? $r('app.color.ohos_id_color_background_base_dark') : $r('app.color.ohos_id_color_background_base'))
          .border({
            width: { left: 1 },
            color: this.isDarkMode ? $r('app.color.ohos_id_color_divider_dark') : $r('app.color.ohos_id_color_divider'),
            style: BorderStyle.Solid
          })
        }
      }
      .width('100%')
      .height('100%')
      .layoutWeight(1)

      // 右侧目录区域
      Column() {
        Text('目录')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .margin({ bottom: 16 })
          .fontColor(this.isDarkMode ? $r('app.color.ohos_id_color_text_primary_dark') : $r('app.color.ohos_id_color_text_primary'))

        // 目录内容
        ForEach(this.content.split('\n').filter((line: string): boolean => line.match(/^#{1,6}\s/) !== null), (line: string) => {
          Text(line.replace(/^#{1,6}\s/, ''))
            .fontSize(16)
            .margin({ bottom: 8 })
            .fontColor(this.isDarkMode ? $r('app.color.ohos_id_color_text_primary_dark') : $r('app.color.ohos_id_color_text_primary'))
        })
      }
      .width(200)
      .height('100%')
      .padding(16)
      .backgroundColor(this.isDarkMode ? $r('app.color.ohos_id_color_background_secondary_dark') : $r('app.color.ohos_id_color_background_secondary'))
    }
    .width('100%')
    .height('100%')
  }
} 