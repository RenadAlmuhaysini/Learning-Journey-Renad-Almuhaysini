// 📁 المكان: View Models

import Foundation  // مكتبة الأساسيات
import Observation // عشان الواجهة تتحدث تلقائياً

// الـ ViewModel الخاص بشاشة تعديل الهدف (LearningGoalView)
@Observable // أي تغيير يحدث الشاشة
final class LearningGoalViewModel {
    private let store: LearningStore // مصدر البيانات

    var topic: String           // الموضوع اللي يعدّله المستخدم
    var duration: GoalDuration  // المدة اللي يختارها
    var showAlert = false       // هل نعرض تنبيه "بتبدأ السلسلة من جديد"؟

    init(store: LearningStore) { // نستقبل مصدر البيانات
        self.store = store // نحفظه
        self.topic = store.data.topic // نعبي الموضوع بالقيمة الحالية
        self.duration = store.data.duration // نعبي المدة بالقيمة الحالية
    }

    var isValid: Bool { // هل الموضوع مو فاضي؟
        !topic.trimmingCharacters(in: .whitespaces).isEmpty // نشيل المسافات ونتأكد إن فيه نص
    }

    var hasChanges: Bool { // هل المستخدم غيّر شي؟
        topic.trimmingCharacters(in: .whitespaces) != store.data.topic || duration != store.data.duration // الموضوع أو المدة تغيروا
    }

    var canSave: Bool { // هل نفعّل زر الحفظ؟
        isValid && (hasChanges || store.goalState != .active) // المدخلات صحيحة + (فيه تغيير أو الهدف خلص/فشل)
    }

    /// لما يضغط زر ✓
    /// ترجع true لو انحفظ مباشرة (عشان الشاشة تتسكر)
    /// ولو الهدف شغال، تعرض التنبيه بدال ما تحفظ
    func confirmTapped() -> Bool {
        if store.goalState == .active { // لو الهدف لسا شغال
            showAlert = true // نعرض التنبيه
            return false // وما نسكر الشاشة
        }
        save() // لو الهدف خلص أو فشل، نحفظ على طول
        return true // ونسكر الشاشة
    }

    func save() { // حفظ الهدف الجديد
        store.startGoal(topic: topic, duration: duration) // نبدأ هدف جديد بالقيم الجديدة
    }
}
