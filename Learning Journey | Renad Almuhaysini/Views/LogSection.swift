// 📁 المكان: Views

import SwiftUI // مكتبة الواجهات

// قسم التسجيل: الدائرة الزجاجية الكبيرة وزر التجميد
struct LogSection: View {
    let viewModel: ActivityViewModel // نستخدم نفس ViewModel الشاشة الرئيسية

    var body: some View { // محتوى القسم
        VStack(spacing: 40) { // ترتيب عمودي بمسافة 40
            Button(action: viewModel.logToday) { // الزر الكبير: يسجل اليوم كتعلم
                Text(viewModel.logTitle) // النص يتغير حسب حالة اليوم
                    .font(.title3.bold()) // خط متوسط عريض
                    .foregroundStyle(viewModel.todayStatus == nil ? Color.white : logTextColor) // أبيض لو ما سجلتي، ولون الحالة لو سجلتي
                    .frame(width: 270, height: 270) // حجم الدائرة
                    .glassEffect(logGlass, in: .circle) // زجاج دائري بلون حسب الحالة
            }
            .buttonStyle(.plain) // نشيل شكل الزر الافتراضي عشان يبان الزجاج بس
            .disabled(viewModel.isLogDisabled) // نقفل الزر لو اليوم مسجل
            VStack(spacing: 12) { // عمود زر التجميد والنص
                Button(viewModel.freezeTitle, action: viewModel.freezeToday) // زر التجميد
                    .buttonStyle(PillButtonStyle(color: .ice, fullWidth: true)) // كبسولة زجاج أزرق بعرض كامل
                    .disabled(!viewModel.canFreeze) // نقفله لو ما يمدي تجمّدين (يصير زجاج غامق)
                Text(viewModel.freezeUsageText) // كم تجميد استخدمتي
                    .font(.footnote) // خط صغير
                    .foregroundStyle(.secondary) // لون رمادي
            }
            .padding(.horizontal, 40) // مسافة 40 يمين ويسار
        }
    }

    private var logGlass: Glass { // نوع زجاج الدائرة الكبيرة حسب حالة اليوم
        switch viewModel.todayStatus { // حسب الحالة
        case nil: .regular.tint(.flame).interactive() // ما سجلتي: زجاج برتقالي يتفاعل مع اللمس
        case .learned: .regular.tint(.flame.opacity(0.25)) // تعلمتي: زجاج برتقالي خفيف
        case .freezed: .regular.tint(.ice.opacity(0.25))   // جمدتي: زجاج أزرق خفيف
        }
    }

    private var logTextColor: Color { // لون النص بعد التسجيل
        viewModel.todayStatus == .freezed ? .ice : .flame // أزرق لو مجمد، برتقالي لو تعلمتي
    }
}
