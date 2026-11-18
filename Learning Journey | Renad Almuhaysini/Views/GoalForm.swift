// 📁 المكان: Views

import SwiftUI // مكتبة الواجهات

// نموذج كتابة الموضوع واختيار المدة
// نستخدمه في شاشتين: OnboardingView و LearningGoalView
struct GoalForm: View {
    @Binding var topic: String          // الموضوع، مربوط بقيمة من الشاشة الأم (أي تعديل يرجع لها)
    @Binding var duration: GoalDuration // المدة، مربوطة بقيمة من الشاشة الأم
    @FocusState private var isTopicFocused: Bool // هل خانة الكتابة عليها التركيز (الكيبورد مفتوح)؟

    var body: some View { // محتوى النموذج
        VStack(alignment: .leading, spacing: 28) { // ترتيب عمودي، محاذاة يسار، مسافة 28
            VStack(alignment: .leading, spacing: 10) { // قسم الموضوع
                Text("I want to learn") // السؤال
                    .font(.title3) // خط متوسط
                TextField("Swift", text: $topic) // خانة الكتابة، و"Swift" نص تلميحي
                    .font(.title3) // خط متوسط
                    .wordsCapitalization() // أول حرف من كل كلمة كبير (دالة من Theme.swift)
                    .autocorrectionDisabled() // نوقف التصحيح التلقائي
                    .focused($isTopicFocused) // نربط الخانة بحالة التركيز
                    .frame(maxWidth: .infinity, alignment: .leading) // الخانة تاخذ العرض كامل
                Divider() // خط فاصل تحت الخانة
            }
            .contentShape(Rectangle()) // نخلي القسم كله قابل للضغط، مو بس النص
            .onTapGesture { isTopicFocused = true } // أي ضغطة على القسم تفتح الكيبورد على الخانة

            VStack(alignment: .leading, spacing: 12) { // قسم المدة
                Text("I want to learn it in a") // السؤال
                    .font(.title3) // خط متوسط
                GlassEffectContainer(spacing: 8) { // حاوية الزجاج: تخلي الأزرار الزجاجية تتحرك مع بعض بنعومة
                    HStack(spacing: 8) { // صف أزرار المدة
                        ForEach(GoalDuration.allCases) { option in // نمر على كل المدد (أسبوع، شهر، سنة)
                            Button(option.rawValue) { // زر باسم المدة
                                withAnimation(.smooth) { // نحرك التغيير بنعومة
                                    duration = option // لما ينضغط، نختار هذي المدة
                                }
                            }
                            .buttonStyle(PillButtonStyle(color: duration == option ? .flame : nil)) // المختار زجاج برتقالي، الباقي زجاج غامق
                        }
                    }
                }
            }
        }
    }
}
