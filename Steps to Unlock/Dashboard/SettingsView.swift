//import SwiftUI
//
//struct SettingsView: View {
//
//    @Environment(\.dismiss) private var dismiss
//    
//    var body: some View {
//        // 3. NavigationStack for Header and Toolbar
//        NavigationStack {
//            ScrollView(showsIndicators: false) {
//                VStack(alignment: .leading, spacing: 0) {
//                    
//                    // Section: APPS
//                    SectionHeader(
//                        icon: "app.shadow",
//                        title: "APPS",
//                        subtitle: "Select the apps you want to lock"
//                    )
//                    .padding(.top, 24)
//                    
//                    NavigationLink(destination: ManageAppsView()) {
//                        HStack {
//                            Text("Manage Locked Apps")
//                                .font(.body)
//                                .foregroundStyle(.primary)
//                            
//                            Spacer()
//                            
//                            Image(systemName: "chevron.right")
//                                .font(.system(size: 14, weight: .semibold))
//                                .foregroundStyle(Color(uiColor: .tertiaryLabel))
//                        }
//                        .padding(.horizontal, 16)
//                        .padding(.vertical, 16)
//                        .background(Color(uiColor: .secondarySystemGroupedBackground))
//                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
//                    }
//                    .buttonStyle(.plain)
//                    .padding(.bottom, 32)
//                    
//    
//                    .padding(.vertical, 20)
//                    .frame(maxWidth: .infinity)
//                    .background(Color(uiColor: .secondarySystemGroupedBackground))
//                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
//                    .padding(.bottom, 32)
//
//                    // Section: STEP TARGET TO UNLOCK
//                    SectionHeader(
//                        icon: "figure.walk",
//                        title: "STEP TARGET TO UNLOCK",
//                        subtitle: "Hit this step goal to earn an extra 30 minutes when your daily allowance runs out"
//                    )
//                    
//                    VStack(spacing: 8) {
//                        HStack {
//                            Text("Steps")
//                                .font(.body)
//                            Spacer()
//                            Text("(.stepTarget)")
//                                .font(.headline)
//                                .foregroundStyle(.indigo)
//                        }
//                        
//                        Slider(value: .stepTarget, in: 100...3000, step: 100)
//                            .tint(.indigo)
//                        
//                        HStack {
//                            Text("100")
//                                .font(.caption)
//                                .foregroundStyle(.secondary)
//                            Spacer()
//                            Text("3000")
//                                .font(.caption)
//                                .foregroundStyle(.secondary)
//                        }
//                    }
//                    .padding(.horizontal, 16)
//                    .padding(.vertical, 12)
//                    .background(Color(uiColor: .secondarySystemGroupedBackground))
//                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
//                    
//                    Spacer().frame(height: 60)
//                }
//                .padding(.horizontal, 24)
//            }
//            .background(Color(uiColor: .systemGroupedBackground).ignoresSafeArea())
//            
//            // Native Modifier for Title and Done Button
//            .navigationTitle("Settings")
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                ToolbarItem(placement: .topBarTrailing) {
//                    Image(systemName: "checkmark")
//                        .font(.system(size: 17, weight: .semibold))
//                        .foregroundStyle(Color(uiColor: .tertiaryLabel))
//                        .contentShape(Rectangle())
//                        .onTapGesture {
//                            dismiss()
//                        }
//                }
//            }
//        }
//        
//    }
//}
//
//#Preview {
//    Color.clear.sheet(isPresented: .constant(true)) {
//        SettingsView()
//    }
//}
