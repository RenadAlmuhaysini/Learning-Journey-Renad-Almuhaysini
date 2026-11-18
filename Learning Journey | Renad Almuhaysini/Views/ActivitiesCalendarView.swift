// 📁 المكان: Views

import SwiftUI // مكتبة الواجهات

// شاشة التقويم: تعرض كل الشهور وأيامها الملونة
struct ActivitiesCalendarView: View {
    @State private var viewModel: ActivitiesCalendarViewModel // الـ ViewModel الخاص بالشاشة
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 7) // 7 أعمدة مرنة (لأيام الأسبوع)

    init(store: LearningStore) { // نستقبل مصدر البيانات
        _viewModel = State(initialValue: ActivitiesCalendarViewModel(store: store)) // وننشئ الـ ViewModel مرة وحدة
    }

    var body: some View { // محتوى الشاشة
        ScrollView { // نخلي الشاشة تنسحب لتحت
            LazyVStack(alignment: .leading, spacing: 32) { // عمود يحمّل الشهور وقت ظهورها بس (أخف)
                ForEach(viewModel.months, id: \.self) { month in // نمر على كل شهر
                    let days = viewModel.gridDays(for: month) // نجيب أيام هذا الشهر
                    VStack(alignment: .leading, spacing: 14) { // عمود للشهر الواحد
                        Text(month, format: .dateTime.month(.wide).year()) // اسم الشهر والسنة، مثلاً: November 2026
                            .font(.title3.bold()) // خط متوسط عريض
                        LazyVGrid(columns: columns, spacing: 12) { // شبكة من 7 أعمدة
                            ForEach(viewModel.weekdaySymbols, id: \.self) { symbol in // نمر على أسماء الأيام
                                Text(symbol) // اسم اليوم (SUN, MON...)
                                    .font(.caption2.bold()) // خط صغير عريض
                                    .foregroundStyle(.secondary) // لون رمادي
                            }
                            ForEach(Array(days.enumerated()), id: \.offset) { _, day in // نمر على أيام الشهر مع ترقيمها
                                if let day { // لو الخانة فيها يوم
                                    DayCircle(date: day, status: viewModel.status(for: day), isToday: viewModel.isToday(day), size: 38) // دائرة اليوم
                                } else { // لو الخانة فاضية (قبل أول يوم بالشهر)
                                    Color.clear // مساحة شفافة
                                        .frame(height: 38) // بنفس ارتفاع الدائرة
                                }
                            }
                        }
                    }
                }
            }
            .padding() // مسافة من كل الجهات
        }
        .navigationTitle("Activities") // عنوان الشاشة
        .inlineTitle() // العنوان صغير بالسطر
    }
}

#Preview { // معاينة في Xcode
    NavigationStack { // داخل NavigationStack عشان يبين العنوان
        ActivitiesCalendarView(store: LearningStore()) // نعرض الشاشة
    }
    .preferredColorScheme(.dark) // بالوضع الداكن
}
