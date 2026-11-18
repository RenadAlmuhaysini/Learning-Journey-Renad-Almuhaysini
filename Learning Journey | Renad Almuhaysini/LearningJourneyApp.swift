// 📁 المكان: جذر المشروع MyApp (برا المجلدات الثلاثة)

import SwiftUI // نستورد مكتبة SwiftUI عشان نبني الواجهات

@main // يحدد إن هذا هو نقطة بداية التطبيق (أول شي يشتغل)
struct LearningJourneyApp: App { // التطبيق نفسه، يطبّق بروتوكول App
    @State private var store = LearningStore() // ننشئ مصدر البيانات مرة وحدة ونخليه عايش طول عمر التطبيق

    var body: some Scene { // المشهد الرئيسي للتطبيق
        WindowGroup { // النافذة اللي تظهر فيها الشاشات
            RootView(store: store) // أول شاشة، ونمرر لها مصدر البيانات
                .preferredColorScheme(.dark) // نجبر التطبيق يكون بالوضع الداكن
        }
    }
}
