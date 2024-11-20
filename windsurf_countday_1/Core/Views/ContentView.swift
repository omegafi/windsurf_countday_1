import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \SpecialDay.date) private var specialDays: [SpecialDay]
    @State private var showingAddSheet = false
    @State private var showSettings = false
    @AppStorage("selectedViewMode") private var selectedViewMode: ViewMode = .cards
    
    private var countdownDays: [SpecialDay] {
        specialDays.filter { !$0.isCountingForward }
    }
    
    private var countupDays: [SpecialDay] {
        specialDays.filter { $0.isCountingForward }
    }
    
    private func cycleViewMode() {
        withAnimation {
            selectedViewMode = selectedViewMode.nextMode
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Statistics Header
                StatisticsHeaderView(specialDays: specialDays)
                    .padding()
                    .background(Color(.systemBackground))
                
                // Main Content
                ScrollView {
                    VStack(spacing: 20) {
                        // View Mode Button
                        Button(action: cycleViewMode) {
                            Label(selectedViewMode.title, systemImage: selectedViewMode.icon)
                                .foregroundColor(.blue)
                                .padding()
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                        
                        // Countdown Section
                        if !countdownDays.isEmpty {
                            SectionHeaderView(title: "Upcoming Events", count: countdownDays.count)
                            SpecialDaysListView(days: countdownDays, viewMode: selectedViewMode)
                        }
                        
                        // Countup Section
                        if !countupDays.isEmpty {
                            SectionHeaderView(title: "Days Since", count: countupDays.count)
                            SpecialDaysListView(days: countupDays, viewMode: selectedViewMode)
                        }
                    }
                }
            }
            .navigationTitle("Special Days")
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddSheet = true }) {
                        Image(systemName: "plus.circle.fill")
                            .imageScale(.large)
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { showSettings = true }) {
                        Image(systemName: "gear")
                            .imageScale(.large)
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddSpecialDayView()
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
        }
    }
}

// MARK: - Supporting Views

struct StatisticsHeaderView: View {
    let specialDays: [SpecialDay]
    
    private var totalCount: Int { specialDays.count }
    private var countdownCount: Int { specialDays.filter { !$0.isCountingForward }.count }
    private var countupCount: Int { specialDays.filter { $0.isCountingForward }.count }
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Your Special Days")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            HStack(spacing: 20) {
                StatCard(title: "Total", count: totalCount, color: .blue)
                StatCard(title: "Upcoming", count: countdownCount, color: .green)
                StatCard(title: "Past", count: countupCount, color: .purple)
            }
        }
        .padding()
        .background(Color(.systemBackground))
    }
}

struct StatCard: View {
    let title: String
    let count: Int
    let color: Color
    
    var body: some View {
        VStack(spacing: 10) {
            Text("\(count)")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(12)
        .background(color.opacity(0.1))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(color.opacity(0.2), lineWidth: 1)
        )
        .transition(.scale)
    }
}

struct SectionHeaderView: View {
    let title: String
    let count: Int
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
            
            Spacer()
            
            Text("\(count)")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color(.systemGray6))
                .cornerRadius(8)
        }
        .padding(.horizontal)
    }
}

struct SpecialDaysListView: View {
    let days: [SpecialDay]
    let viewMode: ViewMode
    
    var body: some View {
        switch viewMode {
        case .list:
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(days) { day in
                        SpecialDayRowView(day: day)
                    }
                }
                .padding()
            }
            
        case .cards:
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ForEach(days) { day in
                        SpecialDayCardView(day: day)
                    }
                }
                .padding()
            }
            
        case .grid:
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 16) {
                    ForEach(days) { day in
                        SpecialDayGridItemView(day: day)
                    }
                }
                .padding()
            }
        }
    }
}

struct TypeSectionView: View {
    let type: SpecialDayType
    let days: [SpecialDay]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: type.icon)
                    .foregroundColor(Color(hex: type.defaultColor))
                
                Text(type.rawValue)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text("\(days.count)")
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .padding(4)
                    .background(Color(hex: type.defaultColor))
                    .cornerRadius(8)
            }
            .padding(.horizontal)
            
            VStack(spacing: 10) {
                ForEach(days) { day in
                    SpecialDayRowView(day: day)
                }
            }
        }
        .background(Color(hex: type.defaultColor).opacity(0.05))
        .cornerRadius(16)
    }
}

struct TypeSliderSectionView: View {
    let type: SpecialDayType
    let days: [SpecialDay]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: type.icon)
                    .foregroundColor(Color(hex: type.defaultColor))
                
                Text(type.rawValue)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text("\(days.count)")
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .padding(4)
                    .background(Color(hex: type.defaultColor))
                    .cornerRadius(8)
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(days) { day in
                        SpecialDaySliderView(day: day)
                            .frame(width: UIScreen.main.bounds.width * 0.85)
                    }
                }
                .padding(.horizontal)
            }
        }
        .background(Color(hex: type.defaultColor).opacity(0.05))
        .cornerRadius(16)
    }
}

struct TypeGridSectionView: View {
    let type: SpecialDayType
    let days: [SpecialDay]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: type.icon)
                    .foregroundColor(Color(hex: type.defaultColor))
                
                Text(type.rawValue)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text("\(days.count)")
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .padding(4)
                    .background(Color(hex: type.defaultColor))
                    .cornerRadius(8)
            }
            .padding(.horizontal)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                ForEach(days) { day in
                    SpecialDayGridItemView(day: day)
                }
            }
            .padding(.horizontal)
        }
        .background(Color(hex: type.defaultColor).opacity(0.05))
        .cornerRadius(16)
    }
}

enum ViewMode: String, CaseIterable {
    case list, cards, grid
    
    var title: String {
        switch self {
        case .list: return "List View"
        case .cards: return "Card View"
        case .grid: return "Grid View"
        }
    }
    
    var icon: String {
        switch self {
        case .list: return "list.bullet"
        case .cards: return "square.stack"
        case .grid: return "square.grid.2x2"
        }
    }
    
    var nextMode: ViewMode {
        switch self {
        case .cards: return .list
        case .list: return .grid
        case .grid: return .cards
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: SpecialDay.self)
}
