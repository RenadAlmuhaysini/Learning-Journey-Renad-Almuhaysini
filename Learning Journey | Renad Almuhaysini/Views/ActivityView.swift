// 📁 المكان: Views

import SwiftUI // مكتبة الواجهات

// الشاشة الرئيسية: الأسبوع، العدادات، وزر التسجيل
struct ActivityView: View {
    @State private var viewModel: ActivityViewModel // الـ ViewModel الخاص بالشاشة

    init(store: LearningStore) { // نستقبل مصدر البيانات
        _viewModel = State(initialValue: ActivityViewModel(store: store)) // وننشئ الـ ViewModel مرة وحدة
    }

    var body: some View { // محتوى الشاشة
        VStack(spacing: 24) { // ترتيب عمودي بمسافة 24
            Text(Date.now, format: .dateTime.weekday(.wide).day().month(.wide)) // تاريخ اليوم، مثلاً: Tuesday, 17 November
                .foregroundStyle(.secondary) // لون رمادي
                .frame(maxWidth: .infinity, alignment: .leading) // ياخذ العرض كامل ومحاذى يسار
            WeekStrip(viewModel: viewModel) // شريط أيام الأسبوع
            HStack(spacing: 12) { // صف البطاقتين
                StatCard(icon: "flame.fill", color: .flame, value: viewModel.learnedCount, label: "Learned") // بطاقة أيام التعلم
                StatCard(icon: "snowflake", color: .ice, value: viewModel.freezedCount, label: "Freezed") // بطاقة أيام التجميد
            }
            Spacer() // مسافة مرنة
            switch viewModel.goalState { // نعرض محتوى مختلف حسب حالة الهدف
            case .active: // الهدف شغال
                LogSection(viewModel: viewModel) // نعرض الدائرة الكبيرة وزر التجميد
            case .completed: // الهدف اكتمل
                GoalEndView(store: viewModel.store, icon: "hands.clap.fill", title: "Well done!", message: "Ready for your next goal?") // رسالة تهنئة
            case .failed: // الهدف فشل
                GoalEndView(store: viewModel.store, icon: "xmark.seal.fill", title: "You didn't reach your goal this time.", message: "Want to set another goal?") // رسالة فشل
            }
            Spacer() // مسافة مرنة
        }
        .padding(.horizontal) // مسافة من اليمين واليسار
        .navigationTitle("Activity") // عنوان الشاشة فوق
        .toolbar { // أزرار الشريط العلوي (في iOS 26 تصير دوائر زجاجية تلقائياً)
            ToolbarItem(placement: .primaryAction) { // زر التقويم
                NavigationLink { // زر ينقلنا لشاشة ثانية
                    ActivitiesCalendarView(store: viewModel.store) // شاشة التقويم
                } label: {
                    Image(systemName: "calendar") // أيقونة التقويم
                }
            }
            ToolbarSpacer(.fixed, placement: .primaryAction) // فاصل عشان كل زر يكون دائرة زجاج لحاله (مثل التصميم)
            ToolbarItem(placement: .primaryAction) { // زر تعديل الهدف
                NavigationLink { // زر ينقلنا لشاشة ثانية
                    LearningGoalView(store: viewModel.store) // شاشة تعديل الهدف
                } label: {
                    Image(systemName: "pencil.and.outline") // أيقونة القلم
                }
            }
        }
    }
}

#Preview { // معاينة في Xcode
    NavigationStack { // نحطها داخل NavigationStack عشان يبين العنوان والأزرار
        ActivityView(store: LearningStore()) // نعرض الشاشة
    }
    .preferredColorScheme(.dark) // بالوضع الداكن
}
