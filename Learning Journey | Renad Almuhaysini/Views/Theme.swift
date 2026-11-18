// 📁 المكان: Views

import SwiftUI // مكتبة الواجهات

// ألوان التطبيق
extension Color { // نضيف ألوان جديدة على Color
    static let flame = Color(red: 1.0, green: 0.57, blue: 0.19) // البرتقالي (لون التعلم)
    static let ice = Color(red: 0.0, green: 0.78, blue: 0.9)    // الأزرق (لون التجميد)
    static let card = Color(white: 0.12)                         // الرمادي الغامق (خلفية البطاقات)
}

// دوال مساعدة للواجهات
extension View { // نضيف دوال جديدة على كل الـ Views
    @ViewBuilder // يسمح نرجع واجهات مختلفة حسب الشرط
    func inlineTitle() -> some View { // يخلي عنوان الشاشة صغير بالسطر
        #if os(iOS) // لو التطبيق شغال على آيفون/آيباد
        self.navigationBarTitleDisplayMode(.inline) // العنوان صغير بالسطر
        #else // لو على نظام ثاني (مثل ماك)
        self // نرجع الواجهة بدون تغيير
        #endif
    }

    @ViewBuilder // يسمح نرجع واجهات مختلفة حسب الشرط
    func wordsCapitalization() -> some View { // يخلي أول حرف من كل كلمة كبير
        #if os(iOS) // لو على آيفون/آيباد
        self.textInputAutocapitalization(.words) // أول حرف كبير
        #else // لو على نظام ثاني
        self // نرجع الواجهة بدون تغيير
        #endif
    }
}
