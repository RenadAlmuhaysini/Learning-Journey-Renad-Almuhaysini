# 🔥 Learning Journey

A SwiftUI iOS app that helps you build a daily learning habit. Pick what you want to learn, choose how long you'll commit (a week, a month, or a year), and log your progress every day to keep your streak alive.

Built with **SwiftUI**, the **Observation** framework, and **Liquid Glass**, using the **MVVM** architecture.

---

## 📱 Screenshots

| Onboarding | Activity | Goal Completed | Goal Failed |
|:---:|:---:|:---:|:---:|
| ![Onboarding](Screenshots/onboarding.png) | ![Activity](Screenshots/activity.png) | ![Completed](Screenshots/completed.png) | ![Failed](Screenshots/failed.png) |

> Add your screenshots to a `Screenshots/` folder in the repo root using the file names above.

---

## ✨ Features

- **Set a learning goal**: type the topic you want to learn and choose a duration: **Week**, **Month**, or **Year**.
- **Log your day**: tap the big button once a day to mark the day as *Learned*.
- **Freeze a day**: take a break without losing your streak. The number of freezes depends on the goal length.
- **Weekly strip**: see the current week at a glance, with each day colored by its status.
- **Activity calendar**: browse every month of your journey in a full calendar view.
- **Goal outcomes**: get a *"Well done!"* screen when you finish, or a prompt to try again if the streak breaks.
- **Edit your goal**: change the topic or duration at any time. The app warns you first, because updating an active goal restarts the streak.
- **Saved on device**: your progress is kept between launches with `UserDefaults`.
- **Liquid Glass UI**: glass buttons, cards, and controls in a dark theme.

---

## 📏 Goal Rules

| Duration | Days | Freezes allowed |
|---|:---:|:---:|
| Week | 7 | 2 |
| Month | 30 | 8 |
| Year | 365 | 96 |

- A goal is **completed** when learned days plus frozen days reach the goal's length.
- A goal **fails** if more than **32 hours** pass without logging or freezing a day.
- Each day can be logged **once**, either as *Learned* or *Freezed*.

---

## 🏗 Architecture: MVVM

The project is split into three layers:

```
Learning Journey | Renad Almuhaysini/
├── LearningJourneyApp.swift              # App entry point
│
├── Models/                                # Data and business rules
│   ├── GoalDuration.swift                 # Week / Month / Year, with days and freeze limits
│   ├── DayStatus.swift                    # learned / freezed
│   ├── GoalState.swift                    # active / completed / failed
│   ├── LearningData.swift                 # The data that gets saved (Codable)
│   └── LearningStore.swift                # Shared source of truth: saving + goal logic
│
├── View Models/                           # One ViewModel per screen
│   ├── OnboardingViewModel.swift
│   ├── ActivityViewModel.swift
│   ├── LearningGoalViewModel.swift
│   └── ActivitiesCalendarViewModel.swift
│
└── Views/                                 # UI only, no business logic
    ├── RootView.swift                     # Shows onboarding or the main screen
    ├── OnboardingView.swift
    ├── ActivityView.swift
    ├── LearningGoalView.swift
    ├── ActivitiesCalendarView.swift
    ├── WeekStrip.swift
    ├── LogSection.swift
    ├── GoalEndView.swift
    ├── GoalForm.swift
    ├── StatCard.swift
    ├── DayCircle.swift
    ├── FlameBadge.swift
    ├── PillButtonStyle.swift              # Shared Liquid Glass button style
    └── Theme.swift                        # App colors and view helpers
```

**How the layers talk to each other**

```
View  ──asks──▶  ViewModel  ──reads/writes──▶  LearningStore (Model)
  ▲                                                   │
  └────────── updates automatically (@Observable) ────┘
```

- **Model**: `LearningStore` is the only place that changes or saves data.
- **ViewModel**: prepares what each screen needs (text, counts, button states) and passes user actions to the store.
- **View**: draws the UI and calls the ViewModel when the user does something.

---

## 🛠 Tech Stack

- **Language:** Swift
- **UI:** SwiftUI
- **State:** Observation framework (`@Observable`)
- **Design:** Liquid Glass (`glassEffect`, `GlassEffectContainer`)
- **Storage:** `UserDefaults` with `Codable` / JSON
- **Architecture:** MVVM

---

## 🚀 Getting Started

### Requirements
- A Mac with Xcode that supports iOS 26 or later
- An iPhone or simulator running iOS 26 or later (Liquid Glass needs iOS 26)

### Run the app
1. Clone the repo:
   ```bash
   git clone https://github.com/RenadAlmuhaysini/Learning-Journey-Renad-Almuhaysini.git
   ```
2. Open `Learning Journey | Renad Almuhaysini.xcodeproj` in Xcode.
3. Pick an iPhone simulator, for example iPhone 17.
4. Press **⌘R** to build and run.

---

## 👩‍💻 Author

**Renad Almuhaysini**

- Portfolio: [renad-almuhaysini.netlify.app](https://renad-almuhaysini.netlify.app)
- GitHub: [@RenadAlmuhaysini](https://github.com/RenadAlmuhaysini)
