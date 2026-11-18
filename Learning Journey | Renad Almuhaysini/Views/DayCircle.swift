// 📁 المكان: Views

import SwiftUI // مكتبة الواجهات

// دائرة رقم اليوم، لونها حسب حالته
// نستخدمها في WeekStrip وفي شاشة التقويم
struct DayCircle: View {
    var date: Date          // تاريخ اليوم
    var status: DayStatus?  // حالته (تعلم/تجميد/ولا شي)
    var isToday = false     // هل هو اليوم الحالي؟
    var size: CGFloat = 40  // حجم الدائرة (الافتراضي 40)

    var body: some View { // محتوى الدائرة
        Text(date, format: .dateTime.day()) // رقم اليوم
            .font(.headline) // خط عريض
            .foregroundStyle(foreground) // لون الرقم
            .frame(width: size, height: size) // مقاس الدائرة
            .background(Circle().fill(background)) // خلفية دائرية بلون الحالة
    }

    private var background: Color { // لون خلفية الدائرة
        switch status { // حسب الحالة
        case .learned: isToday ? .flame : .flame.opacity(0.25) // تعلم: برتقالي كامل لو اليوم، شفاف لو يوم قبل
        case .freezed: isToday ? .ice : .ice.opacity(0.25)     // تجميد: أزرق كامل لو اليوم، شفاف لو يوم قبل
        case nil: isToday ? .flame : .clear                    // ولا شي: برتقالي لو اليوم، شفاف لو لا
        }
    }

    private var foreground: Color { // لون الرقم
        switch status { // حسب الحالة
        case .learned: isToday ? .white : .flame // تعلم: أبيض لو اليوم، برتقالي لو لا
        case .freezed: isToday ? .white : .ice   // تجميد: أبيض لو اليوم، أزرق لو لا
        case nil: .white                         // ولا شي: أبيض
        }
    }
}
