// 📁 المكان: Views

import SwiftUI // مكتبة الواجهات

// شريط أيام الأسبوع في الشاشة الرئيسية
struct WeekStrip: View {
    let viewModel: ActivityViewModel // نستخدم نفس ViewModel الشاشة الرئيسية

    var body: some View { // محتوى الشريط
        HStack(spacing: 0) { // صف أفقي بدون مسافات
            ForEach(viewModel.weekDays, id: \.self) { day in // نمر على كل يوم في الأسبوع
                VStack(spacing: 8) { // عمود لكل يوم
                    Text(day, format: .dateTime.weekday(.narrow)) // أول حرف من اسم اليوم (S, M, T...)
                        .font(.caption.bold()) // خط صغير عريض
                        .foregroundStyle(.secondary) // لون رمادي
                    DayCircle(date: day, status: viewModel.status(for: day), isToday: viewModel.isToday(day)) // دائرة رقم اليوم بلون حالته
                }
                .frame(maxWidth: .infinity) // كل يوم ياخذ مساحة متساوية
            }
        }
    }
}
