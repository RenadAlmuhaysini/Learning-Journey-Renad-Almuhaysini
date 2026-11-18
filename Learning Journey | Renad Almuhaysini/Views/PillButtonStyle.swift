// 📁 المكان: Views

import SwiftUI // مكتبة الواجهات

// شكل موحد للأزرار: كبسولة زجاجية (Liquid Glass)
// لو أعطيناها لون ← زجاج ملوّن (مثل Start Learning و Freeze)
// لو بدون لون أو الزر مقفول ← زجاج غامق والنص رمادي (مثل Month و Year)
struct PillButtonStyle: ButtonStyle { // يطبّق بروتوكول ButtonStyle
    var color: Color? = nil // لون الزجاج (nil = زجاج غامق بدون لون)
    var fullWidth = false   // هل ياخذ العرض كامل؟ (الافتراضي لا)
    @Environment(\.isEnabled) private var isEnabled // نعرف إذا الزر مفعّل أو مقفول

    private var tint: Color? { isEnabled ? color : nil } // اللون الفعلي: لو الزر مقفول نشيل اللون

    func makeBody(configuration: Configuration) -> some View { // نبني شكل الزر
        configuration.label // نص الزر الأصلي
            .font(.body) // خط عادي (مثل التصميم)
            .foregroundStyle(tint == nil ? Color.secondary : Color.white) // أبيض لو ملوّن، رمادي لو غامق
            .padding(.horizontal, 22) // مسافة 22 يمين ويسار
            .padding(.vertical, 12) // مسافة 12 فوق وتحت
            .frame(maxWidth: fullWidth ? .infinity : nil) // عرض كامل لو fullWidth، غير كذا على قد النص
            .glassEffect(glass, in: .capsule) // تأثير الزجاج بشكل كبسولة
            .scaleEffect(configuration.isPressed ? 0.96 : 1) // يصغر شوي لما ينضغط
            .animation(.smooth(duration: 0.2), value: configuration.isPressed) // حركة ناعمة للضغط
    }

    private var glass: Glass { // نوع الزجاج
        if let tint { // لو فيه لون
            return .regular.tint(tint).interactive() // زجاج ملوّن ويتفاعل مع اللمس
        }
        return .regular.interactive() // غير كذا زجاج غامق ويتفاعل مع اللمس
    }
}
