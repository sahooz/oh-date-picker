import { DateUtil } from '../utils/DateUtil'

@Component
export struct DateTimePicker {
  @Prop @Watch('calculateDataSet') config: DateTimePickerConfig = {
    format: DateTimeFormat.YmdHm,
    start: '1900-01-01 00:00',
    end: '2099-12-31 23:59',
    selected: DateUtil.getTodayStr('yyyy-MM-dd HH:mm')
  }
  @Prop suffixes: ISuffixes = new Suffixes()
  @Prop @Watch('calculateDataSet') suffixMode: SuffixMode = SuffixMode.Together
  @Prop loopMode: LoopMode = LoopMode.Auto
  @Prop textStyle : PickerTextStyle = {}
  @Prop selectedTextStyle : PickerTextStyle = {}
  @Prop disappearTextStyle : PickerTextStyle = {}
  @Prop suffixTextStyle : PickerTextStyle = {}
  onSelectedCallback: (dateTime: DateTime) => void = () => {}

  @State private dataSet: string[][] = []
  private selectedDateTime: DateTime = new DateTime(DateTimeFormat.YmdHm, '1970-01-01 00:00')


  aboutToAppear(): void {
    this.calculateDataSet()
  }

  calculateDataSet() {
    let dataSet : string[][] = []
    let startDate = new DateTime(this.config.format, this.config.start)
    let endDate = new DateTime(this.config.format, this.config.end)
    let selectedDate = new DateTime(this.config.format, this.config.selected)
    if(!this.selectedDateTime.isTheSameSecond(selectedDate)) {
      this.selectedDateTime = selectedDate
    }
    if(startDate.isAfter(endDate)) {
      throw new Error('start must not be a date after end')
    }
    if(this.containsYear()) {
      let years: string[] = []
      for (let i = startDate.year; i <= endDate.year; i++) {
        let year: string = DateUtil.padNumber(i, 4)
        if(this.suffixMode == SuffixMode.Together) {
          year = year + this.suffixes.year
        }
        years.push(year)
      }
      dataSet.push(years)
    }

    if(this.containsMonth()) {
      let months: string[] = []
      let startMonth = 1;
      let endMonth = 12;
      if(selectedDate.isTheSameYear(startDate)) {
        startMonth = startDate.month
      }
      if(selectedDate.isTheSameYear(endDate)) {
        endMonth = endDate.month
      }
      for (let i = startMonth; i <= endMonth; i++) {
        let month: string = DateUtil.padNumber(i, 2)
        if(this.suffixMode == SuffixMode.Together) {
          month = month + this.suffixes.month
        }
        months.push(month)
      }
      dataSet.push(months)
    }

    if(this.containsDay()) {
      let days: string[] = []
      let startDay = 1
      let endDay = DateUtil.getDateCount(new Date(selectedDate.year, selectedDate.month - 1))
      if(selectedDate.isTheSameMonth(startDate)) {
        startDay = startDate.day
      }
      if(selectedDate.isTheSameMonth(endDate)) {
        endDay = endDate.day
      }
      for (let i = startDay; i <= endDay; i++) {
        let day: string = DateUtil.padNumber(i, 2)
        if(this.suffixMode == SuffixMode.Together) {
          day = day + this.suffixes.day
        }
        days.push(day)
      }
      dataSet.push(days)
    }

    if(this.containsHour()) {
      let hours: string[] = []
      let startHour = 0
      let endHour = 23
      if(this.containsDay()) {
        if(selectedDate.isTheSameDay(startDate)) {
          startHour = startDate.hour
        }
        if(selectedDate.isTheSameDay(endDate)) {
          endHour = endDate.hour
        }
      } else {
        startHour = startDate.hour
        endHour = endDate.hour
      }

      for (let i = startHour; i <= endHour; i++) {
        let hour: string = DateUtil.padNumber(i, 2)
        if(this.suffixMode == SuffixMode.Together) {
          hour = hour + this.suffixes.hour
        }
        hours.push(hour)
      }
      dataSet.push(hours)
    }

    if(this.containsMinute()) {
      let minutes: string[] = []
      let startMinute = 0
      let endMinute = 59
      if(this.containsHour()) {
        if(selectedDate.isTheSameHour(startDate)) {
          startMinute = startDate.minute
        }
        if(selectedDate.isTheSameHour(endDate)) {
          endMinute = endDate.minute
        }
      } else {
        startMinute = startDate.minute
        endMinute = endDate.minute
      }

      for (let i = startMinute; i <= endMinute; i++) {
        let minute: string = DateUtil.padNumber(i, 2)
        if(this.suffixMode == SuffixMode.Together) {
          minute = minute + this.suffixes.minute
        }
        minutes.push(minute)
      }
      dataSet.push(minutes)
    }

    if(this.containsSecond()) {
      let seconds: string[] = []
      let startSecond = 0
      let endSecond = 59
      if(this.containsMinute()) {
        if(selectedDate.isTheSameMinute(startDate)) {
          startSecond = startDate.second
        }
        if(selectedDate.isTheSameMinute(endDate)) {
          endSecond = endDate.second
        }
      } else {
        startSecond = startDate.second
        endSecond = endDate.second
      }

      for (let i = startSecond; i <= endSecond; i++) {
        let second: string = DateUtil.padNumber(i, 2)
        if(this.suffixMode == SuffixMode.Together) {
          second = second + this.suffixes.second
        }
        seconds.push(second)
      }
      dataSet.push(seconds)
    }

    this.dataSet = dataSet
  }

  containsYear() : boolean {
    return this.config.format == DateTimeFormat.Ym
      || this.config.format == DateTimeFormat.Ymd
      || this.config.format == DateTimeFormat.YmdHm
      || this.config.format == DateTimeFormat.YmdHms
  }

  containsMonth() : boolean {
    return this.config.format == DateTimeFormat.Ym
      || this.config.format == DateTimeFormat.Ymd
      || this.config.format == DateTimeFormat.YmdHm
      || this.config.format == DateTimeFormat.YmdHms
  }

  containsDay() : boolean {
    return this.config.format == DateTimeFormat.Ymd
      || this.config.format == DateTimeFormat.YmdHm
      || this.config.format == DateTimeFormat.YmdHms
  }

  containsHour() : boolean {
    return this.config.format == DateTimeFormat.YmdHm
      || this.config.format == DateTimeFormat.YmdHms
      || this.config.format == DateTimeFormat.Hm
      || this.config.format == DateTimeFormat.Hms
  }

  containsMinute() : boolean {
    return this.config.format == DateTimeFormat.YmdHm
      || this.config.format == DateTimeFormat.YmdHms
      || this.config.format == DateTimeFormat.Hm
      || this.config.format == DateTimeFormat.Hms
      || this.config.format == DateTimeFormat.Ms
  }

  containsSecond() : boolean {
    return this.config.format == DateTimeFormat.YmdHms
      || this.config.format == DateTimeFormat.Hms
      || this.config.format == DateTimeFormat.Ms
  }

  build() {
    Row() {
      ForEach(this.dataSet, (item: string[], index: number) => {
        TextPicker({
          range: item,
          value: this.getValueForIndex(index)
        }).layoutWeight(1)
          .textStyle(this.textStyle)
          .selectedTextStyle(this.selectedTextStyle)
          .disappearTextStyle(this.disappearTextStyle)
          .padding(0)
          .onChange((value) => {
            this.selectedDateTime = this.selectedDateTime.copy(value as string, index)
            this.config.selected = this.selectedDateTime.format();
            this.calculateDataSet();

            for (let i = index + 1; i < this.dataSet.length; i++) {
              let text = this.getValueForIndex(i)
              let range = this.dataSet[i];
              if(range.every(val => val != text)) {
                this.selectedDateTime = this.selectedDateTime.copy(range[0], i)
                this.config.selected = this.selectedDateTime.format();
              }
            }

            this.onSelectedCallback(this.selectedDateTime)
          }).canLoop(this.canLoop(item))
        if(this.suffixMode == SuffixMode.Separated && this.getSuffixForIndex(index) != '') {
          Text(this.getSuffixForIndex(index))
            .fontColor(this.suffixTextStyle.color ?? this.selectedTextStyle?.color ?? this.textStyle?.color ?? Color.Black)
            .font(this.suffixTextStyle.font?? this.selectedTextStyle?.font ?? this.textStyle?.font ?? {})
        }
      })
    }.alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.Center)
  }

  canLoop(item: string[]) {
    if(this.loopMode == LoopMode.Auto) {
      return item.length > 3
    }
    return this.loopMode == LoopMode.Enable
  }

  getValueForIndex(index: number): string {
    if(index >= this.dataSet.length) {
      return ''
    }
    let value = this.selectedDateTime.valueForIndex(index)
    if(this.suffixMode == SuffixMode.Together) {
      value = value + this.getSuffixForIndex(index)
    }
    return value
  }

  getSuffixForIndex(index: number): string {
    let values = [this.suffixes.year, this.suffixes.month, this.suffixes.day, this.suffixes.hour, this.suffixes.minute, this.suffixes.second]
    switch (this.config.format) {
      case DateTimeFormat.Ym:
      case DateTimeFormat.Ymd:
      case DateTimeFormat.YmdHm:
      case DateTimeFormat.YmdHms:
        return values[index]
      case DateTimeFormat.Hm:
      case DateTimeFormat.Hms:
        return values[index + 3]
      case DateTimeFormat.Ms:
        return values[index + 4]
    }
  }
}

export enum DateTimeFormat {
  Ym, Ymd, YmdHm, YmdHms, Hm, Hms, Ms
}

export class DateTime {
  fmt: DateTimeFormat
  year: number = 0
  month: number = 0
  day: number = 0
  hour: number = 0
  minute: number = 0
  second: number = 0

  constructor(fmt: DateTimeFormat, dateTimeStr: string) {
    this.fmt = fmt
    switch (fmt) {
      case DateTimeFormat.Ym: {
        let splits = dateTimeStr.split('-')
        this.year = Number.parseInt(splits[0])
        this.month = Number.parseInt(splits[1])
        break
      }

      case DateTimeFormat.Ymd: {
        let splits = dateTimeStr.split('-')
        this.year = Number.parseInt(splits[0])
        this.month = Number.parseInt(splits[1])
        this.day = Number.parseInt(splits[2])
        break
      }

      case DateTimeFormat.YmdHm: {
        let splits = dateTimeStr.split(' ')
        let ymd = splits[0].split('-')
        let hm = splits[1].split(':')
        this.year = Number.parseInt(ymd[0])
        this.month = Number.parseInt(ymd[1])
        this.day = Number.parseInt(ymd[2])
        this.hour = Number.parseInt(hm[0])
        this.minute = Number.parseInt(hm[1])
        break
      }

      case DateTimeFormat.YmdHm: {
        let splits = dateTimeStr.split(' ')
        let ymd = splits[0].split('-')
        let hm = splits[1].split(':')
        this.year = Number.parseInt(ymd[0])
        this.month = Number.parseInt(ymd[1])
        this.day = Number.parseInt(ymd[2])
        this.hour = Number.parseInt(hm[0])
        this.minute = Number.parseInt(hm[1])
        break
      }

      case DateTimeFormat.YmdHms: {
        let splits = dateTimeStr.split(' ')
        let ymd = splits[0].split('-')
        let hms = splits[1].split(':')
        this.year = Number.parseInt(ymd[0])
        this.month = Number.parseInt(ymd[1])
        this.day = Number.parseInt(ymd[2])
        this.hour = Number.parseInt(hms[0])
        this.minute = Number.parseInt(hms[1])
        this.second = Number.parseInt(hms[2])
        break
      }

      case DateTimeFormat.Hms: {
        let hms = dateTimeStr.split(':')
        this.hour = Number.parseInt(hms[0])
        this.minute = Number.parseInt(hms[1])
        this.second = Number.parseInt(hms[2])
        break
      }

      case DateTimeFormat.Hm: {
        let hms = dateTimeStr.split(':')
        this.hour = Number.parseInt(hms[0])
        this.minute = Number.parseInt(hms[1])
        break
      }

      case DateTimeFormat.Ms: {
        let ms = dateTimeStr.split(':')
        this.minute = Number.parseInt(ms[0])
        this.second = Number.parseInt(ms[1])
        break
      }
    }
  }

  valueForIndex(index: number) : string {
    let values = [this.year, this.month, this.day, this.hour, this.minute, this.second]
    switch (this.fmt) {
      case DateTimeFormat.Ym:
      case DateTimeFormat.Ymd:
      case DateTimeFormat.YmdHm:
      case DateTimeFormat.YmdHms:
        return DateUtil.padNumber(values[index], index == 0? 4 : 2)
      case DateTimeFormat.Hm:
      case DateTimeFormat.Hms:
        return DateUtil.padNumber(values[index + 3], 2)
      case DateTimeFormat.Ms:
        return DateUtil.padNumber(values[index + 4], 2)
    }
  }

  copy(value: string, index: number): DateTime {
    let values = [this.year, this.month, this.day, this.hour, this.minute, this.second]
    switch (this.fmt) {
      case DateTimeFormat.Ym:
      case DateTimeFormat.Ymd:
      case DateTimeFormat.YmdHm:
      case DateTimeFormat.YmdHms:
        values[index] = Number.parseInt(value)
        break
      case DateTimeFormat.Hm:
      case DateTimeFormat.Hms:
        values[index + 3] = Number.parseInt(value)
        break
      case DateTimeFormat.Ms:
        values[index + 4] = Number.parseInt(value)
        break
    }
    let newDate: DateTime = new DateTime(DateTimeFormat.Ym, '0000-00')
    newDate.fmt = this.fmt
    newDate.year = values[0]
    newDate.month = values[1]
    newDate.day = values[2]
    newDate.hour = values[3]
    newDate.minute = values[4]
    newDate.second = values[5]
    return newDate
  }

  format(): string {
    let fmtStr = ''
    switch (this.fmt) {
      case DateTimeFormat.Ym:
        fmtStr = 'yyyy-MM'
        break
      case DateTimeFormat.Ymd:
        fmtStr = 'yyyy-MM-dd'
        break
      case DateTimeFormat.YmdHm:
        fmtStr = 'yyyy-MM-dd HH:mm'
        break
      case DateTimeFormat.YmdHms:
        fmtStr = 'yyyy-MM-dd HH:mm:ss'
        break
      case DateTimeFormat.Hm:
        fmtStr = 'HH:mm'
        break
      case DateTimeFormat.Hms:
        fmtStr = 'HH:mm:ss'
        break
      case DateTimeFormat.Ms:
        fmtStr = 'mm:ss'
        break
    }
    return fmtStr.replace('yyyy', DateUtil.padNumber(this.year, 4))
      .replace('MM', DateUtil.padNumber(this.month, 2))
      .replace('dd', DateUtil.padNumber(this.day, 2))
      .replace('HH', DateUtil.padNumber(this.hour, 2))
      .replace('mm', DateUtil.padNumber(this.minute, 2))
      .replace('ss', DateUtil.padNumber(this.second, 2))
  }

  isAfter(that: DateTime) : boolean {
    if(this.year != that.year) {
      return this.year > that.year
    }
    if(this.month != that.month) {
      return this.month > that.month
    }
    if(this.day != that.day) {
      return this.day > that.day
    }
    if(this.hour != that.hour) {
      return this.hour > that.hour
    }
    if(this.minute != that.hour) {
      return this.minute > that.minute
    }
    return this.second > that.second
  }

  isTheSameYear(that: DateTime): boolean {
    return this.year == that.year
  }

  isTheSameMonth(that: DateTime) : boolean {
    return this.isTheSameYear(that) && this.month == that.month
  }

  isTheSameDay(that: DateTime) : boolean {
    return this.isTheSameMonth(that) && this.day == that.day
  }

  isTheSameHour(that: DateTime) : boolean {
    return this.isTheSameDay(that) && this.hour == that.hour
  }

  isTheSameMinute(that: DateTime) : boolean {
    return this.isTheSameHour(that) && this.minute == that.minute
  }

  isTheSameSecond(that: DateTime) : boolean {
    return this.isTheSameMinute(that) && this.second == that.second
  }

  millis(): number {
    let date = new Date(this.year, this.month - 1, this.day, this.hour, this.minute, this.second)
    return date.getTime()
  }
}

export interface ISuffixes {
  year: string
  month: string
  day: string
  hour: string
  minute: string
  second: string
}

export class Suffixes implements ISuffixes {
  year: string = '年'
  month: string = '月'
  day: string = '日'
  hour: string = '时'
  minute: string = '分'
  second: string = '秒'
}

export enum SuffixMode {
  Separated, Together
}

export enum LoopMode {
  Auto, Enable, Disable
}

export interface  DateTimePickerConfig {
  format: DateTimeFormat
  start: string
  end: string
  selected: string
}

function copyConfigWithSelected(src: DateTimePickerConfig, selected: string): DateTimePickerConfig {
  return {
    format: src.format,
    start: src.start,
    end: src.end,
    selected: selected
  }
}