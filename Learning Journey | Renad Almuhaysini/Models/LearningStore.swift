// 📁 المكان: Models

import Foundation  // مكتبة الأساسيات (Date, Calendar, UserDefaults)
import Observation // مكتبة المراقبة عشان الواجهة تتحدث تلقائياً لما تتغير البيانات

// مصدر البيانات المشترك: يحفظ البيانات ويطبّق قواعد الهدف
// كل الـ ViewModels تقرأ وتكتب من هذا الكلاس
@Observable // أي تغيير هنا يحدّث الواجهات اللي تستخدمه
final class LearningStore { // final: ما أحد يورث منه
    private let storageKey = "learningData" // اسم المفتاح اللي نحفظ فيه البيانات في UserDefaults
    private let calendar = Calendar.current // التقويم الحالي للجهاز (نستخدمه لحساب الأيام)

    var data: LearningData { // البيانات الحالية
        didSet { save() }    // كل ما تتغير البيانات، نحفظها مباشرة
    }

    init() { // أول ما ينشأ الكلاس
        if let saved = UserDefaults.standard.data(forKey: storageKey), // نجيب البيانات المحفوظة لو موجودة
           let decoded = try? JSONDecoder().decode(LearningData.self, from: saved) { // نحولها من JSON إلى LearningData
            data = decoded // لو نجح، نستخدم البيانات المحفوظة
        } else { // لو ما فيه بيانات محفوظة
            data = LearningData() // نبدأ ببيانات جديدة فاضية
        }
    }

    private func save() { // دالة الحفظ
        if let encoded = try? JSONEncoder().encode(data) { // نحول البيانات إلى JSON
            UserDefaults.standard.set(encoded, forKey: storageKey) // ونحفظها في UserDefaults
        }
    }

    // MARK: - Days (الأيام)

    var today: Date { calendar.startOfDay(for: .now) } // تاريخ اليوم من بداية اليوم (الساعة 12 بالليل)

    func status(for date: Date) -> DayStatus? { // ترجع حالة أي يوم
        data.records[calendar.startOfDay(for: date)] // ندور التاريخ في السجل (من بداية اليوم)
    }

    var todayStatus: DayStatus? { status(for: .now) } // حالة اليوم الحالي

    // MARK: - Goal progress (تقدم الهدف)

    private var currentGoalRecords: [DayStatus] { // سجلات الهدف الحالي بس
        let start = calendar.startOfDay(for: data.startDate) // بداية يوم انطلاق الهدف
        return data.records.filter { $0.key >= start }.map(\.value) // ناخذ الأيام اللي بعد البداية، ونرجع حالاتها
    }

    var learnedCount: Int { currentGoalRecords.filter { $0 == .learned }.count } // كم يوم تعلّمتي

    var freezedCount: Int { currentGoalRecords.filter { $0 == .freezed }.count } // كم يوم جمّدتي

    var freezeLimit: Int { data.duration.freezeLimit } // الحد الأقصى للتجميد حسب المدة

    var canFreeze: Bool { // هل يمديك تجمّدين اليوم؟
        todayStatus == nil && freezedCount < freezeLimit && goalState == .active // اليوم ما تسجل + ما خلّصتي التجميدات + الهدف شغال
    }

    var goalState: GoalState { // نحسب حالة الهدف
        if learnedCount + freezedCount >= data.duration.days { // لو مجموع الأيام وصل مدة الهدف
            return .completed // الهدف اكتمل
        }
        let reference = data.lastActivity ?? data.startDate // آخر نشاط، ولو ما فيه ناخذ تاريخ البداية
        if Date.now.timeIntervalSince(reference) > 32 * 3600 { // لو فات أكثر من 32 ساعة من آخر نشاط
            return .failed // الهدف فشل
        }
        return .active // غير كذا، الهدف شغال
    }

    // MARK: - Actions (الأوامر)

    func logToday() { // تسجيل اليوم إنك تعلمتي
        record(.learned) // نسجل اليوم كـ "تعلّمت"
    }

    func freezeToday() { // تجميد اليوم
        guard canFreeze else { return } // لو ما يمدي تجمّدين، نطلع وما نسوي شي
        record(.freezed) // نسجل اليوم كـ "مجمّد"
    }

    private func record(_ status: DayStatus) { // الدالة اللي تسجل فعلياً
        guard todayStatus == nil, goalState == .active else { return } // لو اليوم مسجل أو الهدف مو شغال، نطلع
        data.records[today] = status // نحط حالة اليوم في السجل
        data.lastActivity = .now // نحدث وقت آخر نشاط للحين
    }

    func startGoal(topic: String, duration: GoalDuration) { // نبدأ هدف جديد
        var updated = data // ناخذ نسخة من البيانات عشان نعدل عليها مرة وحدة
        updated.topic = topic.trimmingCharacters(in: .whitespaces) // نحفظ الموضوع بعد ما نشيل المسافات من الأطراف
        updated.duration = duration // نحفظ المدة
        updated.startDate = .now // تاريخ البداية = الحين
        updated.lastActivity = nil // نصفّر آخر نشاط
        updated.records = data.records.filter { $0.key < today } // نخلي بس الأيام القديمة (قبل اليوم)
        updated.hasOnboarded = true // نعلّم إن المستخدم خلّص شاشة البداية
        data = updated // نحط النسخة المعدلة مرة وحدة (فيصير حفظ واحد بس)
    }

    // MARK: - Calendar helpers (مساعدات التقويم)

    func weekDays() -> [Date] { // ترجع أيام الأسبوع الحالي السبعة
        let start = calendar.dateInterval(of: .weekOfYear, for: .now)?.start ?? today // أول يوم في الأسبوع الحالي
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: start) } // نضيف 0 إلى 6 أيام عليه
    }

    func months() -> [Date] { // ترجع الشهور اللي نعرضها في التقويم
        let earliest = ([data.startDate] + data.records.keys).min() ?? .now // أقدم تاريخ عندنا
        let goalEnd = calendar.date(byAdding: .day, value: data.duration.days, to: data.startDate) ?? .now // تاريخ نهاية الهدف
        let last = max(goalEnd, .now) // آخر تاريخ نعرضه (نهاية الهدف أو اليوم، أيهم أبعد)
        guard var month = calendar.dateInterval(of: .month, for: earliest)?.start else { return [] } // أول يوم في أقدم شهر
        var result: [Date] = [] // مصفوفة الشهور (تبدأ فاضية)
        while month <= last { // نكرر لين نوصل آخر تاريخ
            result.append(month) // نضيف الشهر
            guard let next = calendar.date(byAdding: .month, value: 1, to: month) else { break } // نحسب الشهر اللي بعده
            month = next // ننتقل له
        }
        return result // نرجع الشهور
    }

    func gridDays(for month: Date) -> [Date?] { // ترجع أيام الشهر مرتبة في شبكة التقويم
        guard let range = calendar.range(of: .day, in: .month, for: month) else { return [] } // عدد أيام الشهر (مثلاً 1...30)
        let leadingBlanks = calendar.component(.weekday, from: month) - 1 // كم خانة فاضية قبل أول يوم (حسب يوم الأسبوع)
        let days: [Date?] = range.map { calendar.date(byAdding: .day, value: $0 - 1, to: month) } // نحول كل رقم يوم إلى تاريخ
        return Array(repeating: nil, count: leadingBlanks) + days // الخانات الفاضية + أيام الشهر
    }
}
