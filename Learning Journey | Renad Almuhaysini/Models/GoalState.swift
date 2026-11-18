// 📁 المكان: Models

import Foundation // مكتبة الأساسيات

// حالة الهدف الحالي
enum GoalState {
    case active    // الهدف شغّال
    case completed // الهدف اكتمل
    case failed    // الهدف فشل (فات أكثر من يوم بدون تسجيل)
}
