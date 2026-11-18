// 📁 المكان: Models

import Foundation // مكتبة الأساسيات

// حالة اليوم: يا تعلّمت فيه، يا جمّدته
// String: لها قيمة نصية | Codable: نقدر نحفظها
enum DayStatus: String, Codable {
    case learned // اليوم مسجّل إنك تعلمتي فيه
    case freezed // اليوم مجمّد (استراحة ما تكسر السلسلة)
}
