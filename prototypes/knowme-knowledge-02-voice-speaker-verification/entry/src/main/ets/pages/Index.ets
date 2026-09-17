@Entry
@Component
struct Index {
  build() {
    Column({ space: 12 }) {
      Text('灵犀 · KnowME 语音原型')
        .fontSize(22)
        .fontWeight(FontWeight.Medium)
      Text('GOAL-KK-02 scaffold — buildable skeleton')
        .fontSize(14)
        .fontColor('#666666')
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .backgroundColor('#FFFFFF')
  }
}
