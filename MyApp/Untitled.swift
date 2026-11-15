import SwiftUI
import Observation

@main
struct LearningJourneyApp: App {
    @State private var store = LearningStore()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(store)
                .preferredColorScheme(.dark)
        }
    }
}

enum GoalDuration: String, Codable, CaseIterable, Identifiable {
    case week = "Week"
    case month = "Month"
    case year = "Year"

    var id: String { rawValue }

    var days: Int {
        switch self {
        case .week: 7
        case .month: 30
        case .year: 365
        }
    }

    var freezeLimit: Int {
        switch self {
        case .week: 2
        case .month: 8
        case .year: 96
        }
    }
}

enum DayStatus: String, Codable {
    case learned
    case freezed
}

enum GoalState {
    case active
    case completed
    case failed
}

struct LearningData: Codable {
    var topic: String = ""
    var duration: GoalDuration = .week
    var startDate: Date = .now
    var records: [Date: DayStatus] = [:]
    var lastActivity: Date?
    var hasOnboarded = false
}

@Observable
final class LearningStore {
    private let storageKey = "learningData"
    private let calendar = Calendar.current

    var data: LearningData {
        didSet { save() }
    }

    init() {
        if let saved = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode(LearningData.self, from: saved) {
            data = decoded
        } else {
            data = LearningData()
        }
    }

    private func save() {
        if let encoded = try? JSONEncoder().encode(data) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }

    var today: Date { calendar.startOfDay(for: .now) }

    func status(for date: Date) -> DayStatus? {
        data.records[calendar.startOfDay(for: date)]
    }

    var todayStatus: DayStatus? { status(for: .now) }

    private var currentGoalRecords: [DayStatus] {
        let start = calendar.startOfDay(for: data.startDate)
        return data.records.filter { $0.key >= start }.map(\.value)
    }

    var learnedCount: Int { currentGoalRecords.filter { $0 == .learned }.count }

    var freezedCount: Int { currentGoalRecords.filter { $0 == .freezed }.count }

    var freezeLimit: Int { data.duration.freezeLimit }

    var canFreeze: Bool {
        todayStatus == nil && freezedCount < freezeLimit && goalState == .active
    }

    var goalState: GoalState {
        if learnedCount + freezedCount >= data.duration.days {
            return .completed
        }
        let reference = data.lastActivity ?? data.startDate
        if Date.now.timeIntervalSince(reference) > 32 * 3600 {
            return .failed
        }
        return .active
    }

    func logToday() {
        record(.learned)
    }

    func freezeToday() {
        guard canFreeze else { return }
        record(.freezed)
    }

    private func record(_ status: DayStatus) {
        guard todayStatus == nil, goalState == .active else { return }
        data.records[today] = status
        data.lastActivity = .now
    }

    func startGoal(topic: String, duration: GoalDuration) {
        var updated = data
        updated.topic = topic.trimmingCharacters(in: .whitespaces)
        updated.duration = duration
        updated.startDate = .now
        updated.lastActivity = nil
        updated.records = data.records.filter { $0.key < today }
        updated.hasOnboarded = true
        data = updated
    }

    func weekDays() -> [Date] {
        let start = calendar.dateInterval(of: .weekOfYear, for: .now)?.start ?? today
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: start) }
    }

    func months() -> [Date] {
        let earliest = ([data.startDate] + data.records.keys).min() ?? .now
        let goalEnd = calendar.date(byAdding: .day, value: data.duration.days, to: data.startDate) ?? .now
        let last = max(goalEnd, .now)
        guard var month = calendar.dateInterval(of: .month, for: earliest)?.start else { return [] }
        var result: [Date] = []
        while month <= last {
            result.append(month)
            guard let next = calendar.date(byAdding: .month, value: 1, to: month) else { break }
            month = next
        }
        return result
    }

    func gridDays(for month: Date) -> [Date?] {
        guard let range = calendar.range(of: .day, in: .month, for: month) else { return [] }
        let leadingBlanks = calendar.component(.weekday, from: month) - 1
        let days: [Date?] = range.map { calendar.date(byAdding: .day, value: $0 - 1, to: month) }
        return Array(repeating: nil, count: leadingBlanks) + days
    }
}

extension Color {
    static let flame = Color(red: 1.0, green: 0.57, blue: 0.19)
    static let ice = Color(red: 0.0, green: 0.78, blue: 0.9)
    static let card = Color(white: 0.12)
}

extension View {
    @ViewBuilder
    func inlineTitle() -> some View {
        #if os(iOS)
        self.navigationBarTitleDisplayMode(.inline)
        #else
        self
        #endif
    }

    @ViewBuilder
    func wordsCapitalization() -> some View {
        #if os(iOS)
        self.textInputAutocapitalization(.words)
        #else
        self
        #endif
    }
}

struct PillButtonStyle: ButtonStyle {
    var color: Color
    var fullWidth = false
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundStyle(isEnabled ? Color.white : Color.secondary)
            .padding(.horizontal, 22)
            .padding(.vertical, 14)
            .frame(maxWidth: fullWidth ? .infinity : nil)
            .background(Capsule().fill(isEnabled ? color : Color.card))
            .opacity(configuration.isPressed ? 0.7 : 1)
    }
}

struct RootView: View {
    @Environment(LearningStore.self) private var store

    var body: some View {
        if store.data.hasOnboarded {
            NavigationStack {
                ActivityView()
            }
        } else {
            OnboardingView()
        }
    }
}

struct FlameBadge: View {
    var size: CGFloat

    var body: some View {
        Image(systemName: "flame.fill")
            .font(.system(size: size * 0.45))
            .foregroundStyle(Color.flame)
            .frame(width: size, height: size)
            .background(Circle().fill(Color.flame.opacity(0.15)))
    }
}

struct GoalForm: View {
    @Binding var topic: String
    @Binding var duration: GoalDuration

    var body: some View {
        VStack(alignment: .leading, spacing: 28) {
            VStack(alignment: .leading, spacing: 10) {
                Text("I want to learn")
                    .font(.title3)
                TextField("Swift", text: $topic)
                    .font(.title3)
                    .wordsCapitalization()
                    .autocorrectionDisabled()
                Divider()
            }
            VStack(alignment: .leading, spacing: 12) {
                Text("I want to learn it in a")
                    .font(.title3)
                HStack(spacing: 8) {
                    ForEach(GoalDuration.allCases) { option in
                        Button(option.rawValue) {
                            duration = option
                        }
                        .buttonStyle(PillButtonStyle(color: duration == option ? .flame : .card))
                    }
                }
            }
        }
    }
}

struct OnboardingView: View {
    @Environment(LearningStore.self) private var store
    @State private var topic = ""
    @State private var duration: GoalDuration = .week

    private var isValid: Bool {
        !topic.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 32) {
            HStack {
                Spacer()
                FlameBadge(size: 110)
                Spacer()
            }
            .padding(.top, 40)
            VStack(alignment: .leading, spacing: 6) {
                Text("Hello Learner")
                    .font(.largeTitle.bold())
                Text("This app will help you learn everyday!")
                    .foregroundStyle(.secondary)
            }
            GoalForm(topic: $topic, duration: $duration)
            Spacer()
            VStack(spacing: 10) {
                Button("Start Learning") {
                    store.startGoal(topic: topic, duration: duration)
                }
                .buttonStyle(PillButtonStyle(color: .flame))
                .disabled(!isValid)
                Text("You can edit your desire later")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity)
        }
        .padding(24)
    }
}

struct ActivityView: View {
    @Environment(LearningStore.self) private var store

    var body: some View {
        VStack(spacing: 24) {
            Text(Date.now, format: .dateTime.weekday(.wide).day().month(.wide))
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
            WeekStrip()
            HStack(spacing: 12) {
                StatCard(icon: "flame.fill", color: .flame, value: store.learnedCount, label: "Learned")
                StatCard(icon: "snowflake", color: .ice, value: store.freezedCount, label: "Freezed")
            }
            Spacer()
            switch store.goalState {
            case .active:
                LogSection()
            case .completed:
                GoalEndView(icon: "hands.clap.fill", title: "Well done!", message: "Ready for your next goal?")
            case .failed:
                GoalEndView(icon: "xmark.seal.fill", title: "You didn't reach your goal this time.", message: "Want to set another goal?")
            }
            Spacer()
        }
        .padding(.horizontal)
        .navigationTitle("Activity")
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                NavigationLink {
                    ActivitiesCalendarView()
                } label: {
                    Image(systemName: "calendar")
                }
                NavigationLink {
                    LearningGoalView()
                } label: {
                    Image(systemName: "pencil.and.outline")
                }
            }
        }
    }
}

struct WeekStrip: View {
    @Environment(LearningStore.self) private var store

    var body: some View {
        HStack(spacing: 0) {
            ForEach(store.weekDays(), id: \.self) { day in
                VStack(spacing: 8) {
                    Text(day, format: .dateTime.weekday(.narrow))
                        .font(.caption.bold())
                        .foregroundStyle(.secondary)
                    DayCircle(date: day, status: store.status(for: day), isToday: Calendar.current.isDateInToday(day))
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
}

struct DayCircle: View {
    var date: Date
    var status: DayStatus?
    var isToday = false
    var size: CGFloat = 40

    var body: some View {
        Text(date, format: .dateTime.day())
            .font(.headline)
            .foregroundStyle(foreground)
            .frame(width: size, height: size)
            .background(Circle().fill(background))
    }

    private var background: Color {
        switch status {
        case .learned: isToday ? .flame : .flame.opacity(0.25)
        case .freezed: isToday ? .ice : .ice.opacity(0.25)
        case nil: isToday ? .flame : .clear
        }
    }

    private var foreground: Color {
        switch status {
        case .learned: isToday ? .white : .flame
        case .freezed: isToday ? .white : .ice
        case nil: .white
        }
    }
}

struct StatCard: View {
    var icon: String
    var color: Color
    var value: Int
    var label: String

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)
            Text("\(value) \(value == 1 ? "day" : "days")")
                .font(.title3.bold())
            Text(label)
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(RoundedRectangle(cornerRadius: 24).fill(Color.card))
    }
}

struct LogSection: View {
    @Environment(LearningStore.self) private var store

    var body: some View {
        VStack(spacing: 32) {
            Button(action: store.logToday) {
                Text(logTitle)
                    .font(.title2.bold())
                    .foregroundStyle(store.todayStatus == nil ? Color.white : Color.secondary)
                    .frame(width: 260, height: 260)
                    .background(Circle().fill(logColor))
            }
            .disabled(store.todayStatus != nil)
            VStack(spacing: 10) {
                Button(store.todayStatus == .freezed ? "Freezed for a day" : "Freeze for a day", action: store.freezeToday)
                    .buttonStyle(PillButtonStyle(color: .ice, fullWidth: true))
                    .disabled(!store.canFreeze)
                Text("\(store.freezedCount) out of \(store.freezeLimit) Freezes used")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 40)
        }
    }

    private var logTitle: String {
        switch store.todayStatus {
        case .learned: "Logged as Learned"
        case .freezed: "Day Freezed"
        case nil: "Log as Learned"
        }
    }

    private var logColor: Color {
        switch store.todayStatus {
        case .learned: .card
        case .freezed: .ice.opacity(0.2)
        case nil: .flame
        }
    }
}

struct GoalEndView: View {
    var icon: String
    var title: String
    var message: String

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 56))
                .foregroundStyle(Color.flame)
            Text(title)
                .font(.title3.bold())
                .multilineTextAlignment(.center)
            Text(message)
                .foregroundStyle(.secondary)
            NavigationLink {
                LearningGoalView()
            } label: {
                Label("Set a goal", systemImage: "pencil.and.outline")
            }
            .buttonStyle(PillButtonStyle(color: .flame))
            .padding(.top, 16)
        }
    }
}

struct LearningGoalView: View {
    @Environment(LearningStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    @State private var topic = ""
    @State private var duration: GoalDuration = .week
    @State private var showAlert = false

    private var isValid: Bool {
        !topic.trimmingCharacters(in: .whitespaces).isEmpty
    }

    private var hasChanges: Bool {
        topic.trimmingCharacters(in: .whitespaces) != store.data.topic || duration != store.data.duration
    }

    private var canSave: Bool {
        isValid && (hasChanges || store.goalState != .active)
    }

    var body: some View {
        VStack {
            GoalForm(topic: $topic, duration: $duration)
            Spacer()
        }
        .padding(24)
        .navigationTitle("Learning Goal")
        .inlineTitle()
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    if store.goalState == .active {
                        showAlert = true
                    } else {
                        save()
                    }
                } label: {
                    Image(systemName: "checkmark")
                }
                .disabled(!canSave)
            }
        }
        .alert("Update goal", isPresented: $showAlert) {
            Button("Dismiss", role: .cancel) {}
            Button("Update") {
                save()
            }
        } message: {
            Text("If you update now, your streak will start over.")
        }
        .onAppear {
            topic = store.data.topic
            duration = store.data.duration
        }
    }

    private func save() {
        store.startGoal(topic: topic, duration: duration)
        dismiss()
    }
}

struct ActivitiesCalendarView: View {
    @Environment(LearningStore.self) private var store
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 7)

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 32) {
                ForEach(store.months(), id: \.self) { month in
                    let days = store.gridDays(for: month)
                    VStack(alignment: .leading, spacing: 14) {
                        Text(month, format: .dateTime.month(.wide).year())
                            .font(.title3.bold())
                        LazyVGrid(columns: columns, spacing: 12) {
                            ForEach(Calendar.current.shortWeekdaySymbols, id: \.self) { symbol in
                                Text(symbol.uppercased())
                                    .font(.caption2.bold())
                                    .foregroundStyle(.secondary)
                            }
                            ForEach(Array(days.enumerated()), id: \.offset) { _, day in
                                if let day {
                                    DayCircle(date: day, status: store.status(for: day), isToday: Calendar.current.isDateInToday(day), size: 38)
                                } else {
                                    Color.clear
                                        .frame(height: 38)
                                }
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Activities")
        .inlineTitle()
    }
}

#Preview {
    RootView()
        .environment(LearningStore())
        .preferredColorScheme(.dark)
}

