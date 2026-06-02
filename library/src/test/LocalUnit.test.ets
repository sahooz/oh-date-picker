import { describe, it, expect } from '@ohos/hypium'
import { DateTime, DateTimeFormat } from '../main/ets/components/DateTimePicker'

export default function localUnitTest() {
  describe('DateTime', () => {
    it('formats year and month', 0, () => {
      let dateTime = new DateTime(DateTimeFormat.Ym, '2024-08')

      expect(dateTime.year).assertEqual(2024)
      expect(dateTime.month).assertEqual(8)
      expect(dateTime.format()).assertEqual('2024-08')
    })

    it('formats date', 0, () => {
      let dateTime = new DateTime(DateTimeFormat.Ymd, '2024-08-29')

      expect(dateTime.day).assertEqual(29)
      expect(dateTime.format()).assertEqual('2024-08-29')
    })

    it('formats date time with seconds', 0, () => {
      let dateTime = new DateTime(DateTimeFormat.YmdHms, '2024-08-29 12:34:56')

      expect(dateTime.hour).assertEqual(12)
      expect(dateTime.minute).assertEqual(34)
      expect(dateTime.second).assertEqual(56)
      expect(dateTime.format()).assertEqual('2024-08-29 12:34:56')
    })

    it('formats time-only values', 0, () => {
      expect(new DateTime(DateTimeFormat.Hm, '06:07').format()).assertEqual('06:07')
      expect(new DateTime(DateTimeFormat.Hms, '06:07:08').format()).assertEqual('06:07:08')
      expect(new DateTime(DateTimeFormat.Ms, '07:08').format()).assertEqual('07:08')
    })

    it('copies the changed value without mutating the source', 0, () => {
      let source = new DateTime(DateTimeFormat.YmdHm, '2024-08-29 12:34')
      let copied = source.copy('09', 1)

      expect(source.format()).assertEqual('2024-08-29 12:34')
      expect(copied.format()).assertEqual('2024-09-29 12:34')
      expect(copied.valueForIndex(1)).assertEqual('09')
    })

    it('compares minute boundaries when hours are equal', 0, () => {
      let earlier = new DateTime(DateTimeFormat.Hm, '10:15')
      let later = new DateTime(DateTimeFormat.Hm, '10:20')

      expect(later.isAfter(earlier)).assertTrue()
      expect(earlier.isAfter(later)).assertFalse()
    })

    it('compares second boundaries when minutes are equal', 0, () => {
      let earlier = new DateTime(DateTimeFormat.Hms, '10:20:30')
      let later = new DateTime(DateTimeFormat.Hms, '10:20:31')

      expect(later.isAfter(earlier)).assertTrue()
      expect(earlier.isAfter(later)).assertFalse()
    })
  })
}
