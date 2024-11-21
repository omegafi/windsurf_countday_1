import SwiftUI
import SwiftData

struct SpecialDaySliderView: View {
    let day: SpecialDay
    
    var body: some View {
        NavigationLink(destination: SpecialDayDetailView(day: day)) {
            HStack(spacing: 15) {
                ZStack {
                    Circle()
                        .fill(Color(hex: day.themeColor).opacity(0.2))
                    
                    Image(systemName: day.type.icon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .foregroundColor(Color(hex: day.themeColor))
                }
                .frame(width: 60, height: 60)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(day.title)
                        .font(.headline)
                    
                    Text(day.date, style: .date)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(daysDifference(from: day.date))")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: day.themeColor))
                    
                    Text(day.isCountingForward ? "days since" : "days left")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .background(Color(hex: day.themeColor).opacity(0.05))
            .cornerRadius(16)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct SpecialDayRowView: View {
    let day: SpecialDay
    
    var body: some View {
        NavigationLink(destination: SpecialDayDetailView(day: day)) {
            HStack(spacing: 15) {
                ZStack {
                    Circle()
                        .fill(Color(hex: day.themeColor).opacity(0.2))
                    
                    Image(systemName: day.type.icon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .foregroundColor(Color(hex: day.themeColor))
                }
                .frame(width: 50, height: 50)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(day.title)
                        .font(.headline)
                    
                    Text(day.date, style: .date)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(daysDifference(from: day.date))")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: day.themeColor))
                    
                    Text(day.isCountingForward ? "days since" : "days left")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .background(Color(hex: day.themeColor).opacity(0.05))
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct SpecialDayGridItemView: View {
    let day: SpecialDay
    
    var body: some View {
        NavigationLink(destination: SpecialDayDetailView(day: day)) {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color(hex: day.themeColor).opacity(0.2))
                    
                    Image(systemName: day.type.icon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .foregroundColor(Color(hex: day.themeColor))
                }
                .frame(width: 60, height: 60)
                
                Text(day.title)
                    .font(.headline)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                
                Text("\(daysDifference(from: day.date))")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: day.themeColor))
                
                Text(day.isCountingForward ? "days since" : "days left")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .padding()
            .frame(width: 160, height: 200)
            .background(Color(hex: day.themeColor).opacity(0.05))
            .cornerRadius(16)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct SpecialDayCardView: View {
    let day: SpecialDay
    
    var body: some View {
        NavigationLink(destination: SpecialDayDetailView(day: day)) {
            VStack(alignment: .center, spacing: 15) {
                ZStack {
                    Circle()
                        .fill(Color(hex: day.themeColor).opacity(0.2))
                        .frame(width: 80, height: 80)
                    
                    Image(systemName: day.type.icon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                        .foregroundColor(Color(hex: day.themeColor))
                }
                
                Text(day.title)
                    .font(.title3)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                
                Text(day.date, style: .date)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                VStack(spacing: 4) {
                    Text("\(daysDifference(from: day.date))")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(Color(hex: day.themeColor))
                    
                    Text(day.isCountingForward ? "days since" : "days left")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .frame(width: 200, height: 300)
            .padding()
            .background(Color(hex: day.themeColor).opacity(0.05))
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Helper Functions
private func daysDifference(from date: Date) -> Int {
    Calendar.current.dateComponents([.day], from: Date(), to: date).day ?? 0
}

// MARK: - Color Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    func toHex() -> String? {
        let uic = UIColor(self)
        guard let components = uic.cgColor.components, components.count >= 3 else {
            return nil
        }
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        let hex = String(format: "#%02lX%02lX%02lX", lround(Double(r * 255)), lround(Double(g * 255)), lround(Double(b * 255)))
        return hex
    }
}
