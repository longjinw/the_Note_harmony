import common from '@ohos.app.ability.common';
import { BusinessError, pasteboard } from '@kit.BasicServicesKit';

export interface SelectionMenuTheme {
  imageSize: number;
  buttonSize: number;
  menuSpacing: number;
  editorOptionMargin: number;
  expandedOptionPadding: number;
  defaultMenuWidth: number;
  imageFillColor: Resource;
  backGroundColor: Resource;
  iconBorderRadius: Resource;
  containerBorderRadius: Resource;
  cutIcon: Resource;
  copyIcon: Resource;
  pasteIcon: Resource;
  selectAllIcon: Resource;
  shareIcon: Resource;
  translateIcon: Resource;
  searchIcon: Resource;
  arrowDownIcon: Resource;
  iconPanelShadowStyle: ShadowStyle;
  iconFocusBorderColor: Resource;
}

export const defaultTheme: SelectionMenuTheme = {
  imageSize: 24,
  buttonSize: 48,
  menuSpacing: 8,
  editorOptionMargin: 1,
  expandedOptionPadding: 3,
  defaultMenuWidth: 256,
  imageFillColor: $r('sys.color.ohos_id_color_primary'),
  backGroundColor: $r('sys.color.ohos_id_color_dialog_bg'),
  iconBorderRadius: $r('sys.float.ohos_id_corner_radius_default_m'),
  containerBorderRadius: $r('sys.float.ohos_id_corner_radius_card'),
  cutIcon: $r("sys.media.ohos_ic_public_cut"),
  copyIcon: $r("sys.media.ohos_ic_public_copy"),
  pasteIcon: $r("sys.media.ohos_ic_public_paste"),
  selectAllIcon: $r("sys.media.ohos_ic_public_select_all"),
  shareIcon: $r("sys.media.ohos_ic_public_share"),
  translateIcon: $r("sys.media.ohos_ic_public_translate_c2e"),
  searchIcon: $r("sys.media.ohos_ic_public_search_filled"),
  arrowDownIcon: $r("sys.media.ohos_ic_public_arrow_down"),
  iconPanelShadowStyle: ShadowStyle.OUTER_DEFAULT_MD,
  iconFocusBorderColor: $r('sys.color.ohos_id_color_focused_outline')
}

@Component
export struct RichTextEditor {
  @Prop isDarkMode: boolean;
  @State content: string = '';
  @State selection: number = 0;
  @Link isMarkdownMode: boolean;
  private controller: RichEditorController = new RichEditorController();
  private options: RichEditorOptions = { controller: this.controller };
  private start: number = -1;
  private end: number = -1;
  @State sliderShow: boolean = false;
  @State colorTransparent: Color = Color.Transparent;
  private iconArr: Array<Resource> = [
    $r('sys.media.ohos_ic_public_cut'),
    $r('sys.media.ohos_ic_public_copy'),
    $r('sys.media.ohos_ic_public_paste'),
    $r('sys.media.ohos_ic_public_select_all'),
    $r('sys.media.ohos_ic_public_share')
  ];
  @State iconBgColor: ResourceColor[] = new Array(this.iconArr.length).fill(this.colorTransparent);
  @State pasteEnable: boolean = false;
  @State visibilityValue: Visibility = Visibility.Visible;
  @State textStyle: RichEditorTextStyle = {};
  @State textSize: number = 16;
  @State lineHeight: number = 50;
  @State letterSpacing: number = 20;
  private theme: SelectionMenuTheme = defaultTheme;
  private spanParagraphs: RichEditorParagraphResult[] = [];

  aboutToAppear() {
    if (this.controller) {
      let richEditorSelection = this.controller.getSelection();
      if (richEditorSelection) {
        let start = richEditorSelection.selection[0];
        let end = richEditorSelection.selection[1];
        if (start === 0 && this.controller.getSpans({ start: end + 1, end: end + 1 }).length === 0) {
          this.visibilityValue = Visibility.None;
        } else {
          this.visibilityValue = Visibility.Visible;
        }
      }
    }
    let sysBoard = pasteboard.getSystemPasteboard()
    if (sysBoard && sysBoard.hasDataSync()) {
      this.pasteEnable = true;
    } else {
      this.pasteEnable = false;
    }
  }

  build() {
    Row() {
      // 左侧空白区域
      Blank()
        .width('10%')
      
      // 中间编辑区域
      Column() {
        RichEditor(this.options)
          .width('100%')
          .height('100%')
          .backgroundColor('transparent')
          .padding(16)
          .onSelect((value: RichEditorSelection) => {
            this.start = value.selection[0];
            this.end = value.selection[1];
          })
          .aboutToIMEInput((value: RichEditorInsertValue) => {
            return true;
          })
          .onIMEInputComplete((value: RichEditorTextSpanResult) => {
            this.content = value.value;
          })
          .bindSelectionMenu(RichEditorSpanType.TEXT, this.panel, ResponseType.LongPress, { 
            onDisappear: () => {
              this.sliderShow = false;
            }
          })
          .bindSelectionMenu(RichEditorSpanType.TEXT, this.panel, ResponseType.RightClick, { 
            onDisappear: () => {
              this.sliderShow = false;
            }
          })
          .placeholder("开始输入T...", {
            fontColor: this.isDarkMode ? $r('app.color.ohos_id_color_text_primary_dark') : $r('app.color.ohos_id_color_text_primary'),
            font: {
              size: 18,
              weight: FontWeight.Normal,
              family: "HarmonyOS Sans",
              style: FontStyle.Normal
            }
          })
      }
      .width('70%')
      .height('100%')
      .backgroundColor(this.isDarkMode ? $r('app.color.ohos_id_color_background_base_dark') : $r('app.color.ohos_id_color_background_base'))

      // 右侧按钮区域
      Scroll() {
        Column() {
          Text('预设样式')
            .width('80%')
            .margin({ top: 10 })
            .textAlign(TextAlign.Center)
            .fontSize(16)
            .fontWeight(FontWeight.Medium)

          Button('标题样式')
            .width('80%')
            .margin({ top: 10 })
            .onClick(() => {
              this.controller.setTypingStyle({
                fontWeight: FontWeight.Bold,
                fontColor: Color.Black,
                fontSize: 24,
                fontStyle: FontStyle.Normal,
                decoration: {
                  type: TextDecorationType.None
                }
              });
            })

          Button('正文样式')
            .width('80%')
            .margin({ top: 10 })
            .onClick(() => {
              this.controller.setTypingStyle({
                fontWeight: FontWeight.Normal,
                fontColor: Color.Black,
                fontSize: 16,
                fontStyle: FontStyle.Normal,
                decoration: {
                  type: TextDecorationType.None
                }
              });
            })

          Button('强调样式')
            .width('80%')
            .margin({ top: 10 })
            .onClick(() => {
              this.controller.setTypingStyle({
                fontWeight: FontWeight.Medium,
                fontColor: Color.Pink,
                fontSize: 16,
                fontStyle: FontStyle.Italic,
                decoration: {
                  type: TextDecorationType.Underline,
                  color: Color.Gray
                }
              });
            })

          Divider()
            .margin({ top: 10, bottom: 10 })

          Text('行高: ' + this.lineHeight)
            .width('80%')
            .margin({ top: 10 })
            .textAlign(TextAlign.Center)
          
          Row() {
            Button('行高+')
              .width('40%')
              .onClick(() => {
                this.lineHeight += 5;
                this.controller.updateSpanStyle({
                  start: this.start,
                  end: this.end,
                  textStyle: {
                    lineHeight: this.lineHeight
                  }
                });
              })
            
            Button('行高-')
              .width('40%')
              .onClick(() => {
                this.lineHeight -= 5;
                this.controller.updateSpanStyle({
                  start: this.start,
                  end: this.end,
                  textStyle: {
                    lineHeight: this.lineHeight
                  }
                });
              })
          }
          .width('80%')
          .justifyContent(FlexAlign.SpaceAround)
          .margin({ top: 5 })

          Text('字符间距: ' + this.letterSpacing)
            .width('80%')
            .margin({ top: 10 })
            .textAlign(TextAlign.Center)
          
          Row() {
            Button('间距+')
              .width('40%')
              .onClick(() => {
                this.letterSpacing += 5;
                this.controller.updateSpanStyle({
                  start: this.start,
                  end: this.end,
                  textStyle: {
                    letterSpacing: this.letterSpacing
                  }
                });
              })
            
            Button('间距-')
              .width('40%')
              .onClick(() => {
                this.letterSpacing -= 5;
                this.controller.updateSpanStyle({
                  start: this.start,
                  end: this.end,
                  textStyle: {
                    letterSpacing: this.letterSpacing
                  }
                });
              })
          }
          .width('80%')
          .justifyContent(FlexAlign.SpaceAround)
          .margin({ top: 5 })

          Divider()
            .margin({ top: 10, bottom: 10 })

          Button('段落左对齐')
            .width('80%')
            .margin({ top: 10 })
            .onClick(() => {
              this.controller.updateParagraphStyle({
                start: this.start,
                end: this.end,
                style: {
                  textAlign: TextAlign.Start
                }
              });
            })
          
          Button('段落右对齐')
            .width('80%')
            .margin({ top: 10 })
            .onClick(() => {
              this.controller.updateParagraphStyle({
                start: this.start,
                end: this.end,
                style: {
                  textAlign: TextAlign.End
                }
              });
            })
          
          Button('段落居中')
            .width('80%')
            .margin({ top: 10 })
            .onClick(() => {
              this.controller.updateParagraphStyle({
                start: this.start,
                end: this.end,
                style: {
                  textAlign: TextAlign.Center
                }
              });
            })

          Divider()
            .margin({ top: 10, bottom: 10 })

          Button('获取段落信息')
            .width('80%')
            .margin({ top: 10 })
            .onClick(() => {
              this.spanParagraphs = this.controller.getParagraphs({
                start: this.start,
                end: this.end
              });
              console.info("RichEditor getParagraphs:" + JSON.stringify(this.spanParagraphs));
            })

          Button('更新样式:加粗')
            .width('80%')
            .margin({ top: 10 })
            .onClick(() => {
              this.controller.updateSpanStyle({
                start: this.start,
                end: this.end,
                textStyle: {
                  fontWeight: FontWeight.Bolder
                }
              });
            })
          
          Button('获取选择内容')
            .width('80%')
            .margin({ top: 10 })
            .onClick(() => {
              this.content = "";
              this.controller.getSpans({
                start: this.start,
                end: this.end
              }).forEach(item => {
                if(typeof(item as RichEditorImageSpanResult)['imageStyle'] != 'undefined'){
                  this.content += (item as RichEditorImageSpanResult).valueResourceStr;
                  this.content += "\n";
                } else {
                  if(typeof(item as RichEditorTextSpanResult)['symbolSpanStyle'] != 'undefined') {
                    this.content += (item as RichEditorTextSpanResult).symbolSpanStyle?.fontSize;
                    this.content += "\n";
                  } else {
                    this.content += (item as RichEditorTextSpanResult).value;
                    this.content += "\n";
                  }
                }
              });
            })
          
          Button('删除选择内容')
            .width('80%')
            .margin({ top: 10 })
            .onClick(() => {
              this.controller.deleteSpans({
                start: this.start,
                end: this.end
              });
              this.start = -1;
              this.end = -1;
            })
        }
        .width('100%')
        .alignItems(HorizontalAlign.Center)
      }
      .width('20%')
      .height('100%')
      .backgroundColor(this.isDarkMode ? $r('app.color.ohos_id_color_background_base_dark') : $r('app.color.ohos_id_color_background_base'))
      .scrollBar(BarState.Auto)
      .scrollable(ScrollDirection.Vertical)
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  panel() {
    Column() {
      this.iconPanel()
      if (!this.sliderShow) {
        this.SystemMenu()
      } else {
        this.sliderPanel()
      }
    }.width(256)
  }

  @Builder
  iconPanel() {
    Column() {
      Row({ space: 2 }) {
        ForEach(this.iconArr, (item: Resource, index?: number) => {
          Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
            Image(item)
              .fillColor(this.theme.imageFillColor)
              .width(24)
              .height(24)
              .focusable(true)
              .draggable(false)
          }
          .borderRadius(this.theme.iconBorderRadius)
          .width(this.theme.buttonSize)
          .height(this.theme.buttonSize)
          .onClick(() => {
            if (index as number == 0) {
              this.sliderShow = false;
              if (this.controller) {
                let selection = this.controller.getSelection();
                let spans = selection.spans;
                spans.forEach((item: RichEditorTextSpanResult | RichEditorImageSpanResult) => {
                  if (typeof (item as RichEditorTextSpanResult)['textStyle'] != 'undefined') {
                    let span = item as RichEditorTextSpanResult;
                    this.textStyle = span.textStyle;
                    let start = span.offsetInSpan[0];
                    let end = span.offsetInSpan[1];
                    let offset = span.spanPosition.spanRange[0];
                    if (this.textStyle.fontWeight != FontWeight.Bolder) {
                      this.textStyle.fontWeight = FontWeight.Bolder;
                    } else {
                      this.textStyle.fontWeight = FontWeight.Normal;
                    }
                    this.controller.updateSpanStyle({
                      start: offset + start,
                      end: offset + end,
                      textStyle: this.textStyle
                    })
                  }
                })
              }
            } else if (index as number == 1) {
              this.sliderShow = false;
              if (this.controller) {
                let selection = this.controller.getSelection();
                let spans = selection.spans;
                spans.forEach((item: RichEditorTextSpanResult | RichEditorImageSpanResult) => {
                  if (typeof (item as RichEditorTextSpanResult)['textStyle'] != 'undefined') {
                    let span = item as RichEditorTextSpanResult;
                    this.textStyle = span.textStyle;
                    let start = span.offsetInSpan[0];
                    let end = span.offsetInSpan[1];
                    let offset = span.spanPosition.spanRange[0];
                    if (this.textStyle.fontStyle == FontStyle.Italic) {
                      this.textStyle.fontStyle = FontStyle.Normal;
                    } else {
                      this.textStyle.fontStyle = FontStyle.Italic;
                    }
                    this.controller.updateSpanStyle({
                      start: offset + start,
                      end: offset + end,
                      textStyle: this.textStyle
                    })
                  }
                })
              }
            } else if (index as number == 2) {
              this.sliderShow = false;
              if (this.controller) {
                let selection = this.controller.getSelection();
                let spans = selection.spans;
                spans.forEach((item: RichEditorTextSpanResult | RichEditorImageSpanResult) => {
                  if (typeof (item as RichEditorTextSpanResult)['textStyle'] != 'undefined') {
                    let span = item as RichEditorTextSpanResult;
                    this.textStyle = span.textStyle;
                    let start = span.offsetInSpan[0];
                    let end = span.offsetInSpan[1];
                    let offset = span.spanPosition.spanRange[0];
                    if (this.textStyle.decoration) {
                      if (this.textStyle.decoration.type == TextDecorationType.Underline) {
                        this.textStyle.decoration.type = TextDecorationType.None;
                      } else {
                        this.textStyle.decoration.type = TextDecorationType.Underline;
                      }
                    } else {
                      this.textStyle.decoration = { 
                        type: TextDecorationType.Underline, 
                        color: Color.Black, 
                        style: TextDecorationStyle.SOLID 
                      };
                    }
                    this.controller.updateSpanStyle({
                      start: offset + start,
                      end: offset + end,
                      textStyle: this.textStyle
                    })
                  }
                })
              }
            } else if (index as number == 3) {
              this.sliderShow = !this.sliderShow;
            } else if (index as number == 4) {
              this.sliderShow = false;
              if (this.controller) {
                let selection = this.controller.getSelection();
                let spans = selection.spans;
                spans.forEach((item: RichEditorTextSpanResult | RichEditorImageSpanResult) => {
                  if (typeof (item as RichEditorTextSpanResult)['textStyle'] != 'undefined') {
                    let span = item as RichEditorTextSpanResult;
                    this.textStyle = span.textStyle;
                    let start = span.offsetInSpan[0];
                    let end = span.offsetInSpan[1];
                    let offset = span.spanPosition.spanRange[0];
                    if (this.textStyle.fontColor == Color.Orange || this.textStyle.fontColor == '#FFFFA500') {
                      this.textStyle.fontColor = Color.Black;
                    } else {
                      this.textStyle.fontColor = Color.Orange;
                    }
                    this.controller.updateSpanStyle({
                      start: offset + start,
                      end: offset + end,
                      textStyle: this.textStyle
                    })
                  }
                })
              }
            }
          })
          .onTouch((event?: TouchEvent) => {
            if(event != undefined){
              if (event.type === TouchType.Down) {
                this.iconBgColor[index as number] = $r('sys.color.ohos_id_color_click_effect');
              }
              if (event.type === TouchType.Up) {
                this.iconBgColor[index as number] = this.colorTransparent;
              }
            }
          })
          .onHover((isHover?: boolean) => {
            this.iconBgColor.forEach((icon: ResourceColor, index1) => {
              this.iconBgColor[index1] = this.colorTransparent;
            })
            if(isHover != undefined) {
              this.iconBgColor[index as number] = $r('sys.color.ohos_id_color_hover');
            }
          })
          .backgroundColor(this.iconBgColor[index as number])
        })
      }
    }
    .clip(true)
    .width(this.theme.defaultMenuWidth)
    .padding(this.theme.expandedOptionPadding)
    .borderRadius(this.theme.containerBorderRadius)
    .margin({ bottom: this.theme.menuSpacing })
    .backgroundColor(this.theme.backGroundColor)
    .shadow(this.theme.iconPanelShadowStyle)
  }

  @Builder
  SystemMenu() {
    Column() {
      Menu() {
        if (this.controller) {
          MenuItemGroup() {
            MenuItem({ startIcon: this.theme.cutIcon, content: "剪切", labelInfo: "Ctrl+X" })
              .onClick(() => {
                if (!this.controller) {
                  return
                }
                let richEditorSelection = this.controller.getSelection();
                this.PushDataToPasteboard(richEditorSelection);
                this.controller.deleteSpans({
                  start: richEditorSelection.selection[0],
                  end: richEditorSelection.selection[1]
                })
              })
            MenuItem({ startIcon: this.theme.copyIcon, content: "复制", labelInfo: "Ctrl+C" })
              .onClick(() => {
                if (!this.controller) {
                  return;
                }
                let richEditorSelection = this.controller.getSelection();
                this.PushDataToPasteboard(richEditorSelection)
                this.controller.closeSelectionMenu()
              })
            MenuItem({ startIcon: this.theme.pasteIcon, content: "粘贴", labelInfo: "Ctrl+V" })
              .enabled(this.pasteEnable)
              .onClick(() => {
                if (!this.controller) {
                  return;
                }
                let richEditorSelection = this.controller.getSelection();
                this.PopDataFromPasteboard(richEditorSelection)
              })
            MenuItem({ startIcon: this.theme.selectAllIcon, content: "全选", labelInfo: "Ctrl+A" })
              .visibility(this.visibilityValue)
              .onClick(() => {
                if (!this.controller) {
                  return;
                }
                this.controller.setSelection(-1, -1)
                this.visibilityValue = Visibility.None;
              })
            MenuItem({ startIcon: this.theme.shareIcon, content: "分享", labelInfo: "" })
              .enabled(false)
            MenuItem({ startIcon: this.theme.translateIcon, content: "翻译", labelInfo: "" })
              .enabled(false)
            MenuItem({ startIcon: this.theme.searchIcon, content: "搜索", labelInfo: "" })
              .enabled(false)
          }
        }
      }
      .onVisibleAreaChange([0.0, 1.0], () => {
        if (!this.controller) {
          return;
        }
        let richEditorSelection = this.controller.getSelection();
        let start = richEditorSelection.selection[0];
        let end = richEditorSelection.selection[1];
        if (start === 0 && this.controller.getSpans({ start: end + 1, end: end + 1 }).length === 0) {
          this.visibilityValue = Visibility.None;
        } else {
          this.visibilityValue = Visibility.Visible;
        }
      })
      .radius(this.theme.containerBorderRadius)
      .clip(true)
      .backgroundColor(Color.White)
      .width(this.theme.defaultMenuWidth)
    }
    .width(this.theme.defaultMenuWidth)
  }

  @Builder
  sliderPanel() {
    Column() {
      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        Text('A').fontSize(15)
        Slider({ value: this.textSize, step: 10, style: SliderStyle.InSet })
          .width(210)
          .onChange((value: number, mode: SliderChangeMode) => {
            if (this.controller) {
              let selection = this.controller.getSelection();
              if (mode == SliderChangeMode.End) {
                if (this.textSize == undefined) {
                  this.textSize = 0;
                }
                let spans = selection.spans;
                spans.forEach((item: RichEditorTextSpanResult | RichEditorImageSpanResult) => {
                  if (typeof (item as RichEditorTextSpanResult)['textStyle'] != 'undefined') {
                    this.textSize = Math.max(this.textSize, (item as RichEditorTextSpanResult).textStyle.fontSize);
                  }
                })
              }
              if (mode == SliderChangeMode.Moving || mode == SliderChangeMode.Click) {
                this.start = selection.selection[0];
                this.end = selection.selection[1];
                this.textSize = value;
                this.controller.updateSpanStyle({
                  start: this.start,
                  end: this.end,
                  textStyle: { fontSize: this.textSize }
                })
              }
            }
          })
        Text('A').fontSize(20).fontWeight(FontWeight.Medium)
      }.borderRadius(this.theme.containerBorderRadius)
    }
    .shadow(ShadowStyle.OUTER_DEFAULT_MD)
    .backgroundColor(Color.White)
    .borderRadius(this.theme.containerBorderRadius)
    .padding(15)
    .height(48)
  }

  PushDataToPasteboard(richEditorSelection: RichEditorSelection) {
    let sysBoard = pasteboard.getSystemPasteboard();
    let pasteData = pasteboard.createData(pasteboard.MIMETYPE_TEXT_PLAIN, '');
    if (richEditorSelection.spans && richEditorSelection.spans.length > 0) {
      let count = richEditorSelection.spans.length;
      for (let i = count - 1; i >= 0; i--) {
        let item = richEditorSelection.spans[i]
        if ((item as RichEditorTextSpanResult)?.textStyle) {
          let span = item as RichEditorTextSpanResult;
          let style = span.textStyle;
          let data = pasteboard.createRecord(pasteboard.MIMETYPE_TEXT_PLAIN, span.value.substring(span.offsetInSpan[0], span.offsetInSpan[1]));
          let prop = pasteData.getProperty();
          let temp: Record<string, Object> = {
            'color': style.fontColor,
            'size': style.fontSize,
            'style': style.fontStyle,
            'weight': style.fontWeight,
            'fontFamily': style.fontFamily,
            'decorationType': style.decoration?.type,
            'decorationColor': style.decoration?.color
          };
          prop.additions[i] = temp;
          pasteData.addRecord(data)
          pasteData.setProperty(prop)
        }
      }
    }
    sysBoard.clearData()
    sysBoard.setData(pasteData).then(() => {
      console.info('SelectionMenu copy option, Succeeded in setting PasteData.');
      this.pasteEnable = true;
    }).catch((err: BusinessError) => {
      console.error('SelectionMenu copy option, Failed to set PasteData. Cause:' + err.message);
    })
  }

  PopDataFromPasteboard(richEditorSelection: RichEditorSelection) {
    let start = richEditorSelection.selection[0];
    let end = richEditorSelection.selection[1];
    if (start == end && this.controller) {
      start = this.controller.getCaretOffset();
      end = this.controller.getCaretOffset();
    }
    let moveOffset = 0;
    let sysBoard = pasteboard.getSystemPasteboard();
    sysBoard.getData((err, data) => {
      if (err) {
        return;
      }
      let count = data.getRecordCount();
      for (let i = 0; i < count; i++) {
        const element = data.getRecord(i);
        let tex: RichEditorTextStyle = {
          fontSize: 16,
          fontColor: Color.Black,
          fontWeight: FontWeight.Normal,
          fontFamily: "HarmonyOS Sans",
          fontStyle: FontStyle.Normal,
          decoration: { type: TextDecorationType.None, color: "#FF000000", style: TextDecorationStyle.SOLID }
        }
        if (data.getProperty() && data.getProperty().additions[i]) {
          const tmp = data.getProperty().additions[i] as Record<string, Object | undefined>;
          if (tmp.color) {
            tex.fontColor = tmp.color as ResourceColor;
          }
          if (tmp.size) {
            tex.fontSize = tmp.size as Length | number;
          }
          if (tmp.style) {
            tex.fontStyle = tmp.style as FontStyle;
          }
          if (tmp.weight) {
            tex.fontWeight = tmp.weight as number | FontWeight | string;
          }
          if (tmp.fontFamily) {
            tex.fontFamily = tmp.fontFamily as ResourceStr;
          }
          if (tmp.decorationType && tex.decoration) {
            tex.decoration.type = tmp.decorationType as TextDecorationType;
          }
          if (tmp.decorationColor && tex.decoration) {
            tex.decoration.color = tmp.decorationColor as ResourceColor;
          }
          if (tex.decoration) {
            tex.decoration = { type: tex.decoration.type, color: tex.decoration.color };
          }
        }
        if (element && element.plainText && element.mimeType === pasteboard.MIMETYPE_TEXT_PLAIN && this.controller) {
          this.controller.addTextSpan(element.plainText,
            {
              style: tex,
              offset: start + moveOffset
            }
          )
          moveOffset += element.plainText.length;
        }
      }
      if (this.controller) {
        this.controller.setCaretOffset(start + moveOffset)
        this.controller.closeSelectionMenu()
      }
      if (start != end && this.controller) {
        this.controller.deleteSpans({ start: start + moveOffset, end: end + moveOffset })
      }
    })
  }
} 