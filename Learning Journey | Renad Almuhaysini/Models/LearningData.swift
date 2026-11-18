// 📁 المكان: Models

import Foundation // مكتبة الأساسيات (فيها Date)

// كل البيانات اللي نحفظها عن المستخدم
// Codable: عشان نقدر نحولها JSON ونحفظها
struct LearningData: Codable {
    var topic: String = ""              // الموضوع اللي تبين تتعلمينه (يبدأ فاضي)
    var duration: GoalDuration = .week  // مدة الهدف (الافتراضي أسبوع)
    var startDate: Date = .now          // تاريخ بداية الهدف (الافتراضي الحين)
    var records: [Date: DayStatus] = [:] // سجل الأيام: كل تاريخ وحالته (يبدأ فاضي)
    var lastActivity: Date?             // آخر وقت سجّلتي فيه شي (اختياري، ممكن يكون nil)
    var hasOnboarded = false            // هل خلّصتي شاشة البداية؟ (الافتراضي لا)
}
