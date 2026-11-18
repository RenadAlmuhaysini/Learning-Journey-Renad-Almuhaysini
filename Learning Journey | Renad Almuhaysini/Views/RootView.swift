// 📁 المكان: Views

import SwiftUI // مكتبة الواجهات

// الشاشة الجذرية: تقرر أي شاشة تظهر أول
struct RootView: View {
    let store: LearningStore // مصدر البيانات

    var body: some View { // محتوى الشاشة
        if store.data.hasOnboarded { // لو المستخدم خلّص شاشة البداية
            NavigationStack { // حاوية تسمح بالتنقل بين الشاشات
                ActivityView(store: store) // نعرض الشاشة الرئيسية
            }
        } else { // لو أول مرة يفتح التطبيق
            OnboardingView(store: store) // نعرض شاشة البداية
        }
    }
}

#Preview { // معاينة في Xcode
    RootView(store: LearningStore()) // نعرض الشاشة ببيانات جديدة
        .preferredColorScheme(.dark) // بالوضع الداكن
}
