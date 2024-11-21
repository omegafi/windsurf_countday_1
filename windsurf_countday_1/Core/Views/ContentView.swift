import SwiftUI
import SwiftData

// Görüntüleme modu için enum
enum ViewMode: String, CaseIterable {
    case list, cards, grid
    
    var icon: String {
        switch self {
        case .list: return "list.bullet"
        case .cards: return "square.stack"
        case .grid: return "square.grid.2x2"
        }
    }
    
    var title: String {
        switch self {
        case .list: return "List View"
        case .cards: return "Card View"
        case .grid: return "Grid View"
        }
    }
    
    var nextMode: ViewMode {
        switch self {
        case .list: return .cards
        case .cards: return .grid
        case .grid: return .list
        }
    }
}

// Filtreleme modu için enum
enum FilterMode: String, CaseIterable {
    case all, upcoming, past
    
    var icon: String {
        switch self {
        case .all: return "calendar"
        case .upcoming: return "arrow.forward.circle"
        case .past: return "arrow.backward.circle"
        }
    }
    
    var title: String {
        switch self {
        case .all: return "All Events"
        case .upcoming: return "Upcoming Events"
        case .past: return "Past Events"
        }
    }
    
    var nextMode: FilterMode {
        switch self {
        case .all: return .upcoming
        case .upcoming: return .past
        case .past: return .all
        }
    }
}

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \SpecialDay.date) private var specialDays: [SpecialDay]
    @State private var showingAddSheet = false
    @State private var showSettings = false
    @AppStorage("selectedViewMode") private var selectedViewMode: ViewMode = .cards
    @State private var filterMode: FilterMode = .all
    
    private var filteredDays: [SpecialDay] {
        switch filterMode {
        case .all:
            return specialDays
        case .upcoming:
            return specialDays.filter { !$0.isCountingForward }
        case .past:
            return specialDays.filter { $0.isCountingForward }
        }
    }
    
    private var navigationTitle: String {
        "\(filterMode.title) (\(filteredDays.count))"
    }
    
    private func cycleViewMode() {
        withAnimation {
            selectedViewMode = selectedViewMode.nextMode
        }
    }
    
    private func cycleFilterMode() {
        withAnimation {
            filterMode = filterMode.nextMode
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
                            Image(systemName: selectedViewMode.icon)
                                .foregroundColor(.blue)
                                .padding()
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                        
                        // Events List
                        SpecialDaysListView(days: filteredDays, viewMode: selectedViewMode)
                            .padding(.horizontal)
                    }
                }
            }
            .navigationTitle(navigationTitle)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 16) {
                        Button(action: cycleFilterMode) {
                            Image(systemName: filterMode.icon)
                                .imageScale(.large)
                                .foregroundColor(.purple)
                        }
                        .help(filterMode.title)
                        
                        Button(action: { showingAddSheet = true }) {
                            Image(systemName: "plus.circle.fill")
                                .imageScale(.large)
                        }
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

struct SpecialDaysListView: View {
    let days: [SpecialDay]
    let viewMode: ViewMode
    
    var body: some View {
        switch viewMode {
        case .list:
            LazyVStack(spacing: 12) {
                ForEach(days) { day in
                    SpecialDayRowView(day: day)
                }
            }
            
        case .cards:
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ForEach(days) { day in
                        SpecialDayCardView(day: day)
                    }
                }
            }
            
        case .grid:
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                ForEach(days) { day in
                    SpecialDayGridItemView(day: day)
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: SpecialDay.self)
}
