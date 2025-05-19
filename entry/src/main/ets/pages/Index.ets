import { BaiduNLPService } from '../common/aitest'

@Entry
@Component
struct Index {
  @State
  newsTitle: string = ""
  @State
  newsContent: string = ""
  @State
  summaryResult: string = ""
  @State
  summaryLoading: boolean = false

  // 生成新闻摘要
  generateSummary = async () => {
    if (!this.newsTitle || !this.newsContent) {
      this.summaryResult = "请输入新闻标题和内容";
      return;
    }
    
    this.summaryLoading = true;
    this.summaryResult = "";
    
    try {
      const summary = await BaiduNLPService.generateSummary(this.newsTitle, this.newsContent);
      this.summaryResult = summary;
    } catch (error) {
      this.summaryResult = "生成摘要失败：" + error;
    } finally {
      this.summaryLoading = false;
    }
  }

  build() {
    Column() {
      Scroll() {
        Column({ space: 10 }) {
          TextInput({ placeholder: '请输入新闻标题', text: this.newsTitle })
            .onChange((value: string) => {
              this.newsTitle = value
            })
            .width('100%')
            .height(40)
            .margin({ top: 10 })

          TextArea({ placeholder: '请输入新闻内容', text: this.newsContent })
            .onChange((value: string) => {
              this.newsContent = value
            })
            .width('100%')
            .height(200)
            .margin({ top: 10 })

          Button(this.summaryLoading ? '正在生成摘要...' : '生成摘要')
            .onClick(() => {
              if (!this.summaryLoading) {
                this.generateSummary()
              }
            })
            .margin({ top: 10 })
        }
        .width('100%')
        .padding(16)
      }
      .scrollBar(BarState.Auto)
      .scrollable(ScrollDirection.Vertical)
      .width('100%')
      .layoutWeight(1)

      if (this.summaryResult) {
        Column() {
          Divider()
          Text('摘要结果：')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .margin({ top: 10 })
          Text(this.summaryResult)
            .width('100%')
            .margin({ top: 5, bottom: 10 })
        }
        .width('100%')
        .padding(16)
        .backgroundColor('#F5F5F5')
      }
    }
    .width('100%')
    .height('100%')
  }
}
