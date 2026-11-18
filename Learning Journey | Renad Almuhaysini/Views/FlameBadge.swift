// 📁 المكان: Views

import SwiftUI // مكتبة الواجهات

// شعار الشعلة في شاشة البداية
struct FlameBadge: View {
    var size: CGFloat // حجم الشعار

    var body: some View { // محتوى الشعار
        Image(systemName: "flame.fill") // أيقونة الشعلة من SF Symbols
            .font(.system(size: size * 0.4)) // حجم الأيقونة = 40% من حجم الدائرة
            .foregroundStyle(Color.flame) // لونها برتقالي
            .frame(width: size, height: size) // مقاس الإطار
            .glassEffect(.regular, in: .circle) // دائرة زجاج غامق خلف الشعلة
    }
}
