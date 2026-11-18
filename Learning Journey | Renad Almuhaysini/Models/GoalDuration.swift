// 📁 المكان: Models

import Foundation // مكتبة الأساسيات (التواريخ، النصوص...)

// مدة الهدف: أسبوع أو شهر أو سنة
// String: كل حالة لها قيمة نصية | Codable: نقدر نحفظها | CaseIterable: نقدر نمر على كل الحالات | Identifiable: لها id عشان ForEach
enum GoalDuration: String, Codable, CaseIterable, Identifiable {
    case week = "Week"   // أسبوع، ونصها "Week"
    case month = "Month" // شهر، ونصها "Month"
    case year = "Year"   // سنة، ونصها "Year"

    var id: String { rawValue } // المعرّف = النص نفسه (مطلوب لـ Identifiable)

    var days: Int { // عدد أيام كل مدة
        switch self { // نشوف المدة المختارة
        case .week: 7    // الأسبوع 7 أيام
        case .month: 30  // الشهر 30 يوم
        case .year: 365  // السنة 365 يوم
        }
    }

    var freezeLimit: Int { // كم مرة مسموح تجمّدين يوم في هذي المدة
        switch self { // نشوف المدة المختارة
        case .week: 2    // الأسبوع: يومين تجميد
        case .month: 8   // الشهر: 8 أيام تجميد
        case .year: 96   // السنة: 96 يوم تجميد
        }
    }
}
