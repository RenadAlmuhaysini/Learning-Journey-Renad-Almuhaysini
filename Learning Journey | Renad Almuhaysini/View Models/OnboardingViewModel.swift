// 📁 المكان: View Models

import Foundation  // مكتبة الأساسيات
import Observation // عشان الواجهة تتحدث لما تتغير القيم

// الـ ViewModel الخاص بشاشة البداية (OnboardingView)
@Observable // أي تغيير هنا يحدث الشاشة
final class OnboardingViewModel {
    private let store: LearningStore // مصدر البيانات المشترك

    var topic = ""                    // الموضوع اللي يكتبه المستخدم
    var duration: GoalDuration = .week // المدة المختارة (الافتراضي أسبوع)

    init(store: LearningStore) { // نستقبل مصدر البيانات
        self.store = store // ونحفظه
    }

    var isValid: Bool { // هل المدخلات صحيحة؟
        !topic.trimmingCharacters(in: .whitespaces).isEmpty // الموضوع مو فاضي (بعد شيل المسافات)
    }

    func startLearning() { // لما يضغط "Start Learning"
        guard isValid else { return } // لو الموضوع فاضي، ما نسوي شي
        store.startGoal(topic: topic, duration: duration) // نبدأ الهدف في مصدر البيانات
    }
}
