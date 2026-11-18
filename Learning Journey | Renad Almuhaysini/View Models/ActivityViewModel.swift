// 📁 المكان: View Models

import Foundation  // مكتبة الأساسيات
import Observation // عشان الواجهة تتحدث تلقائياً

// الـ ViewModel الخاص بالشاشة الرئيسية (ActivityView)
// ويستخدمه بعد: WeekStrip و LogSection
@Observable // أي تغيير يحدث الشاشة
final class ActivityViewModel {
    let store: LearningStore // مصدر البيانات (مو private لأن الشاشة تمرره للشاشات الثانية)

    init(store: LearningStore) { // نستقبل مصدر البيانات
        self.store = store // ونحفظه
    }

    // MARK: - State (الحالة)

    var goalState: GoalState { store.goalState }         // حالة الهدف (شغال/مكتمل/فاشل)
    var todayStatus: DayStatus? { store.todayStatus }    // حالة اليوم
    var learnedCount: Int { store.learnedCount }         // عدد أيام التعلم
    var freezedCount: Int { store.freezedCount }         // عدد أيام التجميد
    var canFreeze: Bool { store.canFreeze }              // هل يمدي نجمّد اليوم
    var isLogDisabled: Bool { store.todayStatus != nil } // نقفل زر التسجيل لو اليوم مسجل

    // MARK: - Week strip (شريط الأسبوع)

    var weekDays: [Date] { store.weekDays() } // أيام الأسبوع الحالي

    func status(for day: Date) -> DayStatus? { // حالة أي يوم
        store.status(for: day) // نجيبها من مصدر البيانات
    }

    func isToday(_ day: Date) -> Bool { // هل هذا اليوم هو اليوم الحالي؟
        Calendar.current.isDateInToday(day) // نسأل التقويم
    }

    // MARK: - Texts (النصوص)

    var logTitle: String { // نص الزر الكبير
        switch store.todayStatus { // حسب حالة اليوم
        case .learned: "Logged as Learned" // لو سجلتي تعلم
        case .freezed: "Day Freezed"       // لو جمدتي اليوم
        case nil: "Log as Learned"         // لو ما سجلتي شي
        }
    }

    var freezeTitle: String { // نص زر التجميد
        store.todayStatus == .freezed ? "Freezed for a day" : "Freeze for a day" // يتغير لو اليوم مجمد
    }

    var freezeUsageText: String { // النص تحت زر التجميد
        "\(store.freezedCount) out of \(store.freezeLimit) Freezes used" // مثلاً: 1 out of 2 Freezes used
    }

    // MARK: - Actions (الأوامر)

    func logToday() { // لما يضغط الزر الكبير
        store.logToday() // نسجل اليوم كتعلم
    }

    func freezeToday() { // لما يضغط زر التجميد
        store.freezeToday() // نجمد اليوم
    }
}
