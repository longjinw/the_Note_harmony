import { PermissionManager } from '../common/PermissionManager'
import { Permissions } from '@kit.AbilityKit'
import SpeechRecognizerManager from '../common/SpeechRecognizerManager'

@Entry
@Component
struct Index {
  @State
  text: string = ""
  // 1 申请权限
  fn1 = async () => {
    // 准备好需要申请的权限 麦克风权限
    const permissions: Permissions[] = ["ohos.permission.MICROPHONE"]
    // 检查是否拥有权限
    const isPermission = await PermissionManager.checkPermission(permissions)
    if (!isPermission) {
      //   如果没权限，就主动申请
      await PermissionManager.requestPermission(permissions)
    }
  }
  // 2 实时语音识别
  fn2 = () => {
    SpeechRecognizerManager.init(res => {
      console.log("实时语音识别", JSON.stringify(res))
      this.text = res.result
    })
  }

  // Check if the system supports speech recognition
  checkSpeechRecognitionCapability = () => {
    if (canIUse("SystemCapability.AI.SpeechRecognizer")) {
      console.info("具备语音识别功能")
    } else {
      console.info("不具备语音识别功能")
    }
  }

  // Check if the system supports image insertion
  checkImageInsertionCapability = () => {
    if (canIUse("SystemCapability.Multimedia.Image")) {
      console.info("具备图片插入功能")
    } else {
      console.info("不具备图片插入功能")
    }
  }

  constructor() {
    super()
    this.checkSpeechRecognitionCapability()
  }

  onInit() {
    // Ensure it's also called here for redundancy
    this.checkSpeechRecognitionCapability()
  }

  build() {
    Column({ space: 10 }) {
      Text(this.text)

      Button("申请权限")
        .onClick(this.fn1)
      Button("实时语音识别")
        .onClick(this.fn2)
      Button("检查语音识别功能")
        .onClick(this.checkSpeechRecognitionCapability)
      Button("检查图片插入功能")
        .onClick(this.checkImageInsertionCapability)
    }
    .width("100%")
    .height("100%")
    .justifyContent(FlexAlign.Center)
  }
}
