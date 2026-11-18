// 📁 المكان: Views

import SwiftUI // مكتبة الواجهات

// شاشة البداية: يكتب فيها المستخدم وش يبي يتعلم والمدة
struct OnboardingView: View {
    @State private var viewModel: OnboardingViewModel // الـ ViewModel الخاص بالشاشة (@State يخليه عايش مع الشاشة)

    init(store: LearningStore) { // نستقبل مصدر البيانات
        _viewModel = State(initialValue: OnboardingViewModel(store: store)) // وننشئ الـ ViewModel مرة وحدة
    }

    var body: some View { // محتوى الشاشة
        VStack(alignment: .leading, spacing: 32) { // ترتيب عمودي، محاذاة يسار، ومسافة 32 بين العناصر
            HStack { // ترتيب أفقي عشان نوسّط الشعار
                Spacer() // مسافة مرنة من اليسار
                FlameBadge(size: 110) // شعار الشعلة بحجم 110
                Spacer() // مسافة مرنة من اليمين
            }
            .padding(.top, 40) // مسافة 40 من فوق
            VStack(alignment: .leading, spacing: 6) { // عمود العنوان
                Text("Hello \(Text("Learner").bold())") // "Hello" عادي و "Learner" عريض (مثل التصميم)
                    .font(.largeTitle) // خط كبير
                Text("This app will help you learn everyday!") // الوصف
                    .foregroundStyle(.secondary) // لون رمادي
            }
            GoalForm(topic: $viewModel.topic, duration: $viewModel.duration) // نموذج الموضوع والمدة (مربوط بالـ ViewModel)
            Spacer() // مسافة مرنة تدف الزر لتحت
            VStack(spacing: 10) { // عمود الزر والملاحظة
                Button("Start Learning") { // زر البداية
                    viewModel.startLearning() // نبدأ الهدف
                }
                .buttonStyle(PillButtonStyle(color: .flame)) // كبسولة زجاج برتقالي
                .disabled(!viewModel.isValid) // نقفل الزر لو الموضوع فاضي
                Text("You can edit your desire later") // ملاحظة تحت الزر
                    .font(.footnote) // خط صغير
                    .foregroundStyle(.secondary) // لون رمادي
            }
            .frame(maxWidth: .infinity) // ياخذ العرض كامل عشان يتوسط
        }
        .padding(24) // مسافة 24 من كل الجهات
    }
}

#Preview { // معاينة في Xcode
    OnboardingView(store: LearningStore()) // نعرض الشاشة
        .preferredColorScheme(.dark) // بالوضع الداكن
}
