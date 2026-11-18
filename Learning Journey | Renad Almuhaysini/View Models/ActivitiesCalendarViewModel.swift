// 📁 المكان: View Models

import Foundation  // مكتبة الأساسيات
import Observation // عشان الواجهة تتحدث تلقائياً

// الـ ViewModel الخاص بشاشة التقويم (ActivitiesCalendarView)
@Observable // أي تغيير يحدث الشاشة
final class ActivitiesCalendarViewModel {
    private let store: LearningStore // مصدر البيانات

    init(store: LearningStore) { // نستقبل مصدر البيانات
        self.store = store // ونحفظه
    }

    var months: [Date] { store.months() } // الشهور اللي نعرضها

    var weekdaySymbols: [String] { // أسماء أيام الأسبوع المختصرة
        Calendar.current.shortWeekdaySymbols.map { $0.uppercased() } // مثل SUN, MON... بحروف كبيرة
    }

    func gridDays(for month: Date) -> [Date?] { // أيام شهر معين مرتبة في شبكة
        store.gridDays(for: month) // نجيبها من مصدر البيانات
    }

    func status(for day: Date) -> DayStatus? { // حالة يوم معين
        store.status(for: day) // نجيبها من مصدر البيانات
    }

    func isToday(_ day: Date) -> Bool { // هل هذا اليوم هو اليوم الحالي؟
        Calendar.current.isDateInToday(day) // نسأل التقويم
    }
}
