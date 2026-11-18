// 📁 المكان: Views

import SwiftUI // مكتبة الواجهات

// الرسالة اللي تظهر لما الهدف يخلص أو يفشل
struct GoalEndView: View {
    let store: LearningStore // مصدر البيانات (نحتاجه عشان نفتح شاشة الهدف الجديد)
    var icon: String    // اسم الأيقونة
    var title: String   // العنوان
    var message: String // الرسالة

    var body: some View { // محتوى الرسالة
        VStack(spacing: 12) { // ترتيب عمودي بمسافة 12
            Image(systemName: icon) // الأيقونة
                .font(.system(size: 56)) // حجمها 56
                .foregroundStyle(Color.flame) // لونها برتقالي
            Text(title) // العنوان
                .font(.title3.bold()) // خط متوسط عريض
                .multilineTextAlignment(.center) // لو طال النص، يكون بالوسط
            Text(message) // الرسالة
                .foregroundStyle(.secondary) // لون رمادي
            NavigationLink { // زر ينقلنا لشاشة ثانية
                LearningGoalView(store: store) // شاشة تحديد هدف جديد
            } label: {
                Label("Set a goal", systemImage: "pencil.and.outline") // نص الزر مع أيقونة
            }
            .buttonStyle(PillButtonStyle(color: .flame)) // كبسولة برتقالية
            .padding(.top, 16) // مسافة 16 من فوق
        }
    }
}
