// 📁 المكان: Views

import SwiftUI // مكتبة الواجهات

// شاشة تعديل الهدف
struct LearningGoalView: View {
    @State private var viewModel: LearningGoalViewModel // الـ ViewModel الخاص بالشاشة
    @Environment(\.dismiss) private var dismiss // أمر يسكّر الشاشة ويرجع للي قبلها

    init(store: LearningStore) { // نستقبل مصدر البيانات
        _viewModel = State(initialValue: LearningGoalViewModel(store: store)) // وننشئ الـ ViewModel مرة وحدة
    }

    var body: some View { // محتوى الشاشة
        VStack { // ترتيب عمودي
            GoalForm(topic: $viewModel.topic, duration: $viewModel.duration) // نموذج الموضوع والمدة
            Spacer() // يدف النموذج لفوق
        }
        .padding(24) // مسافة 24 من كل الجهات
        .navigationTitle("Learning Goal") // عنوان الشاشة
        .inlineTitle() // العنوان صغير بالسطر (دالة من Theme.swift)
        .toolbar { // أزرار الشريط العلوي
            ToolbarItem(placement: .confirmationAction) { // زر في مكان التأكيد
                Button { // زر ✓
                    if viewModel.confirmTapped() { // لو انحفظ مباشرة
                        dismiss() // نسكر الشاشة
                    }
                } label: {
                    Image(systemName: "checkmark") // أيقونة ✓
                }
                .disabled(!viewModel.canSave) // نقفله لو ما فيه شي يتحفظ
            }
        }
        .alert("Update goal", isPresented: $viewModel.showAlert) { // التنبيه، يظهر لما showAlert = true
            Button("Dismiss", role: .cancel) {} // زر إلغاء، ما يسوي شي
            Button("Update") { // زر التحديث
                viewModel.save() // نحفظ الهدف الجديد
                dismiss() // ونسكر الشاشة
            }
        } message: {
            Text("If you update now, your streak will start over.") // نص التنبيه
        }
    }
}

#Preview { // معاينة في Xcode
    NavigationStack { // داخل NavigationStack عشان يبين العنوان
        LearningGoalView(store: LearningStore()) // نعرض الشاشة
    }
    .preferredColorScheme(.dark) // بالوضع الداكن
}
