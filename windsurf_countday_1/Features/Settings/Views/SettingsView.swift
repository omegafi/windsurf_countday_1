import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @AppStorage("isFirstLaunch") private var isFirstLaunch = true
    @State private var showOnboarding = false
    @State private var showResetConfirmation = false
    
    private let backgroundColor = Color(.systemGroupedBackground)
    private let secondaryColor = Color(.secondarySystemGroupedBackground)
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    appSection
                    generalSection
                    aboutSection
                    supportSection
                    versionSection
                }
                .padding(.vertical)
            }
            .background(backgroundColor)
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .sheet(isPresented: $showOnboarding) {
            OnboardingView()
        }
        .alert("Reset App", isPresented: $showResetConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Reset", role: .destructive) {
                isFirstLaunch = true
                dismiss()
            }
        } message: {
            Text("This will reset all settings to their defaults. This action cannot be undone.")
        }
    }
    
    private var appSection: some View {
        VStack(alignment: .center, spacing: 12) {
            Image(systemName: "calendar.circle.fill")
                .resizable()
                .frame(width: 60, height: 60)
                .foregroundStyle(.blue)
            
            Text("CountDay")
                .font(.title2.bold())
            
            Text("Track Your Special Moments")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(secondaryColor)
    }
    
    private var generalSection: some View {
        VStack(alignment: .leading, spacing: 1) {
            Text("General")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding(.horizontal)
                .padding(.bottom, 8)
            
            VStack(spacing: 1) {
                Button {
                    showOnboarding = true
                } label: {
                    SettingRow(icon: "book.fill", title: "View Onboarding", iconColor: .blue)
                }
                
                Button {
                    showResetConfirmation = true
                } label: {
                    SettingRow(icon: "arrow.counterclockwise", title: "Reset App", iconColor: .red)
                }
            }
            .background(secondaryColor)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal)
        }
    }
    
    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: 1) {
            Text("About")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding(.horizontal)
                .padding(.bottom, 8)
            
            VStack(spacing: 1) {
                Link(destination: URL(string: "https://www.example.com/privacy")!) {
                    SettingRow(icon: "lock.fill", title: "Privacy Policy", iconColor: .green)
                }
                
                Divider()
                    .padding(.leading, 56)
                
                Link(destination: URL(string: "https://www.example.com/terms")!) {
                    SettingRow(icon: "doc.text.fill", title: "Terms of Service", iconColor: .orange)
                }
            }
            .background(secondaryColor)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal)
        }
    }
    
    private var supportSection: some View {
        VStack(alignment: .leading, spacing: 1) {
            Text("Support")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding(.horizontal)
                .padding(.bottom, 8)
            
            VStack(spacing: 1) {
                Link(destination: URL(string: "mailto:support@example.com")!) {
                    SettingRow(icon: "envelope.fill", title: "Contact Support", iconColor: .purple)
                }
                
                Divider()
                    .padding(.leading, 56)
                
                Link(destination: URL(string: "https://www.example.com")!) {
                    SettingRow(icon: "star.fill", title: "Rate App", iconColor: .yellow)
                }
            }
            .background(secondaryColor)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal)
        }
    }
    
    private var versionSection: some View {
        VStack(alignment: .leading, spacing: 1) {
            Text("App Info")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding(.horizontal)
                .padding(.bottom, 8)
            
            HStack {
                Label {
                    Text("Version")
                } icon: {
                    Image(systemName: "info.circle.fill")
                        .foregroundStyle(.blue)
                }
                
                Spacer()
                
                Text("1.0.0")
                    .foregroundStyle(.secondary)
            }
            .padding()
            .background(secondaryColor)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal)
        }
    }
}

struct SettingRow: View {
    let icon: String
    let title: String
    let iconColor: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .frame(width: 24, height: 24)
                .foregroundStyle(iconColor)
                .padding(.trailing, 8)
            
            Text(title)
                .foregroundStyle(.primary)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.footnote.bold())
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}

#Preview {
    SettingsView()
}
