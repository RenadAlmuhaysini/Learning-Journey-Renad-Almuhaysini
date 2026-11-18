// 📁 المكان: Views

import SwiftUI // مكتبة الواجهات

// بطاقة العداد (أيام التعلم أو أيام التجميد) بزجاج غامق
struct StatCard: View {
    var icon: String   // اسم الأيقونة
    var color: Color   // لون الأيقونة
    var value: Int     // الرقم
    var label: String  // العنوان تحت الرقم

    var body: some View { // محتوى البطاقة
        VStack(spacing: 6) { // ترتيب عمودي بمسافة 6
            Image(systemName: icon) // الأيقونة
                .font(.title3) // حجمها
                .foregroundStyle(color) // لونها
            Text("\(value) \(value == 1 ? "day" : "days")") // الرقم + day أو days حسب العدد
                .font(.headline) // خط عريض
            Text(label) // العنوان
                .font(.caption) // خط صغير
        }
        .frame(maxWidth: .infinity) // البطاقة تاخذ العرض المتاح
        .padding(.vertical, 18) // مسافة 18 فوق وتحت
        .glassEffect(.regular, in: .rect(cornerRadius: 22)) // زجاج غامق بدون لون، بزوايا دائرية (مثل التصميم)
    }
}
