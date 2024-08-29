import {
  DateTime,
  DateTimeFormat,
  DateTimePicker,
  DateTimePickerConfig,
  DateUtil,
  LoopMode,
  SuffixMode
} from 'date-time-picker'

@Entry
@Component
struct Index {
  @State @Watch('conConfigChanged') config : DateTimePickerConfig = {
    format: DateTimeFormat.YmdHm,
    start: '1900-01-01 00:00',
    end: '2099-12-31 23:59',
    selected: DateUtil.getTodayStr('yyyy-MM-dd HH:mm')
  }
  @State suffixMode: SuffixMode = SuffixMode.Together
  @State selected: DateTime = new DateTime(this.config.format, this.config.selected)

  conConfigChanged() {
    this.selected = new DateTime(this.config.format, this.config.selected)
  }

  build() {
    Column() {
      DateTimePicker({
        config: this.config,
        suffixMode: this.suffixMode,
        selectedTextStyle: {
          font: {
            size: 15
          },
          color: Color.Black
        },
        textStyle: {
          font: {
            size: 13
          }
        },
        suffixTextStyle: {
          font: {
            size: 15
          },
          color: Color.Black
        },
        onSelectedCallback: (selected) => {
          this.selected = selected
        },
        suffixes: {
          year: '年',
          month: '月',
          day: '日',
          hour: '时',
          minute: '分',
          second: '秒'
        },
        loopMode: LoopMode.Auto
      }).width('100%')

      Blank()
      Text(`当前选择：${this.selected.format()}`)
      Blank()

      Row() {
        Button('年月', { type: ButtonType.Normal, stateEffect: true })
          .borderRadius(8)
          .backgroundColor(0x317aff)
          .width(90)
          .onClick(() => {
            this.config = {
              format : DateTimeFormat.Ym,
              start : '1900-08',
              end : '2100-08',
              selected : '2024-08'
            }
          })

        Button('年月日', { type: ButtonType.Normal, stateEffect: true })
          .borderRadius(8)
          .backgroundColor(0x317aff)
          .width(90)
          .onClick(() => {
            this.config = {
              format : DateTimeFormat.Ymd,
              start : '1900-08-29',
              end : '2100-08-29',
              selected : '2024-08-29'
            }
          })

        Button('年月日时分', { type: ButtonType.Normal, stateEffect: true })
          .borderRadius(8)
          .backgroundColor(0x317aff)
          .width(90)
          .onClick(() => {
            this.config = {
              format : DateTimeFormat.YmdHm,
              start : '1900-08-29 12:00',
              end : '2100-08-29 12:00',
              selected : '2024-08-29 12:00'
            }
          })
      }.width('100%')
      .height(52)
      .justifyContent(FlexAlign.SpaceAround)

      Row() {
        Button('年月日时分秒', { type: ButtonType.Normal, stateEffect: true })
          .borderRadius(8)
          .backgroundColor(0x317aff)
          .width(90)
          .onClick(() => {
            this.config = {
              format : DateTimeFormat.YmdHms,
              start : '1900-08-29 12:00:00',
              end : '2100-08-29 12:00:00',
              selected : '2024-08-29 12:00:00'
            }
          })
        Button('时分秒', { type: ButtonType.Normal, stateEffect: true })
          .borderRadius(8)
          .backgroundColor(0x317aff)
          .width(90)
          .onClick(() => {
            this.config = {
              format : DateTimeFormat.Hms,
              start : '00:00:00',
              end : '12:00:00',
              selected : '06:00:00'
            }
          })
        Button('时分', { type: ButtonType.Normal, stateEffect: true })
          .borderRadius(8)
          .backgroundColor(0x317aff)
          .width(90)
          .onClick(() => {
            this.config = {
              format : DateTimeFormat.Hm,
              start : '00:00',
              end : '12:00',
              selected : '06:00'
            }
          })
      }.width('100%')
      .height(52)
      .justifyContent(FlexAlign.SpaceAround)

      Row() {
        Button('分秒', { type: ButtonType.Normal, stateEffect: true })
          .borderRadius(8)
          .backgroundColor(0x317aff)
          .width(90)
          .onClick(() => {
            this.config = {
              format : DateTimeFormat.Ms,
              start : '00:00',
              end : '12:00',
              selected : '06:00'
            }
          })
        Button('后缀独立', { type: ButtonType.Normal, stateEffect: true })
          .borderRadius(8)
          .backgroundColor(0x317aff)
          .width(90)
          .onClick(() => {
            this.suffixMode = SuffixMode.Separated
          })
        Button('后缀非独立', { type: ButtonType.Normal, stateEffect: true })
          .borderRadius(8)
          .backgroundColor(0x317aff)
          .width(90)
          .onClick(() => {
            this.suffixMode = SuffixMode.Together
          })
      }.width('100%')
      .height(52)
      .justifyContent(FlexAlign.SpaceAround)

    }.width('100%')
    .height('100%')
  }
}