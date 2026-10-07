import SwiftUI

struct OnboardingView: View {
    var onComplete: () -> Void
    
    @State private var currentStep: Int = 0
    @State private var isYearly: Bool = true
    
    var body: some View {
        ZStack {
            Color.auraBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top Dots & Skip
                HStack {
                    HStack(spacing: 6) {
                        ForEach(0..<5) { idx in
                            Capsule()
                                .fill(currentStep == idx ? Color.auraAmber : Color.white.opacity(0.18))
                                .frame(width: currentStep == idx ? 22 : 6, height: 6)
                                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: currentStep)
                        }
                    }
                    
                    Spacer()
                    
                    if currentStep < 4 {
                        Button("Skip") {
                            onComplete()
                        }
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Color.auraTextMuted)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                
                // Content Swiper
                TabView(selection: $currentStep) {
                    step1TalkToNova.tag(0)
                    step2ConnectApps.tag(1)
                    step3Routines.tag(2)
                    step4LiveActivities.tag(3)
                    step5Paywall.tag(4)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                // Bottom Button
                if currentStep < 4 {
                    Button {
                        AuraHaptic.selection()
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                            currentStep += 1
                        }
                    } label: {
                        Text("Continue")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Capsule().fill(Color.auraAmber))
                            .shadow(color: Color.auraAmber.opacity(0.35), radius: 10, y: 4)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                }
            }
        }
    }
    
    // MARK: - Step 1: Talk to Nova
    private var step1TalkToNova: some View {
        VStack(spacing: 24) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(Color.auraAmber.opacity(0.15))
                    .frame(width: 130, height: 130)
                
                Image(systemName: "bubble.left.and.bubble.right.fill")
                    .font(.system(size: 54))
                    .foregroundStyle(Color.auraAmber)
            }
            
            VStack(spacing: 10) {
                Text("Talk to Nova\nlike a friend")
                    .font(.system(size: 32, weight: .bold, design: .serif))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                
                Text("Describe what's on your mind. Aura turns loose thoughts into crisp reminders and schedules.")
                    .font(.system(size: 15))
                    .foregroundStyle(Color.auraTextSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            
            Spacer()
        }
    }
    
    // MARK: - Step 2: Connect Apps
    private var step2ConnectApps: some View {
        VStack(spacing: 24) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.15))
                    .frame(width: 130, height: 130)
                
                Image(systemName: "link.circle.fill")
                    .font(.system(size: 54))
                    .foregroundStyle(Color.blue)
            }
            
            VStack(spacing: 10) {
                Text("Connect what\nyou already use")
                    .font(.system(size: 32, weight: .bold, design: .serif))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                
                Text("Sync seamlessly with Telegram, Apple Calendar, and Google Workspace.")
                    .font(.system(size: 15))
                    .foregroundStyle(Color.auraTextSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            
            // Interactive Calendar Permission Button
            Button {
                AuraHaptic.medium()
                Task {
                    _ = await PermissionsManager.shared.requestCalendarAccess()
                }
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: PermissionsManager.shared.isCalendarAuthorized ? "checkmark.circle.fill" : "calendar.badge.plus")
                        .font(.system(size: 16))
                        .foregroundStyle(PermissionsManager.shared.isCalendarAuthorized ? Color.auraSuccess : Color.auraAmber)
                    
                    Text(PermissionsManager.shared.isCalendarAuthorized ? "Calendar Connected" : "Connect Apple Calendar")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.white)
                }
                .padding(.horizontal, 18)
                .padding(.vertical, 10)
                .background(Capsule().fill(Color.auraCard))
                .overlay(Capsule().stroke(Color.auraBorder, lineWidth: 0.8))
            }
            
            Spacer()
        }
    }
    
    // MARK: - Step 3: Routines
    private var step3Routines: some View {
        VStack(spacing: 24) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(Color.orange.opacity(0.15))
                    .frame(width: 130, height: 130)
                
                Image(systemName: "sun.max.fill")
                    .font(.system(size: 54))
                    .foregroundStyle(Color.auraAmber)
            }
            
            VStack(spacing: 10) {
                Text("Never miss your\nmorning rhythm")
                    .font(.system(size: 32, weight: .bold, design: .serif))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                
                Text("Receive automated briefs for weather, financial updates, and day schedules right on time.")
                    .font(.system(size: 15))
                    .foregroundStyle(Color.auraTextSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            
            Spacer()
        }
    }
    
    // MARK: - Step 4: Live Activities
    private var step4LiveActivities: some View {
        VStack(spacing: 24) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(Color.purple.opacity(0.15))
                    .frame(width: 130, height: 130)
                
                Image(systemName: "bell.badge.fill")
                    .font(.system(size: 54))
                    .foregroundStyle(Color.purple)
            }
            
            VStack(spacing: 10) {
                Text("Stay on top with\nLive Activities")
                    .font(.system(size: 32, weight: .bold, design: .serif))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                
                Text("Active countdowns directly on Dynamic Island and your Lock Screen.")
                    .font(.system(size: 15))
                    .foregroundStyle(Color.auraTextSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            
            // Interactive Notification Permission Button
            Button {
                AuraHaptic.medium()
                Task {
                    _ = await PermissionsManager.shared.requestNotificationAccess()
                }
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: PermissionsManager.shared.isNotificationAuthorized ? "checkmark.circle.fill" : "bell.fill")
                        .font(.system(size: 16))
                        .foregroundStyle(PermissionsManager.shared.isNotificationAuthorized ? Color.auraSuccess : Color.auraAmber)
                    
                    Text(PermissionsManager.shared.isNotificationAuthorized ? "Notifications Enabled" : "Enable Notifications")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.white)
                }
                .padding(.horizontal, 18)
                .padding(.vertical, 10)
                .background(Capsule().fill(Color.auraCard))
                .overlay(Capsule().stroke(Color.auraBorder, lineWidth: 0.8))
            }
            
            Spacer()
        }
    }
    
    // MARK: - Step 5: Paywall
    private var step5Paywall: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "sparkles")
                .font(.system(size: 40))
                .foregroundStyle(Color.auraAmber)
            
            VStack(spacing: 6) {
                Text("Unlock Memory AI\nUnlimited")
                    .font(.system(size: 28, weight: .bold, design: .serif))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                
                Text("Unlimited conversational tokens, biometric cloud sync & Priority Nova AI.")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.auraTextSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
            }
            
            // Plan Selector Cards
            VStack(spacing: 12) {
                // Yearly Option
                Button {
                    AuraHaptic.selection()
                    isYearly = true
                } label: {
                    HStack {
                        VStack(alignment: .leading, spacing: 3) {
                            HStack(spacing: 8) {
                                Text("Annual Plan")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundStyle(.white)
                                Text("SAVE 60%")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundStyle(.black)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(Capsule().fill(Color.auraAmber))
                            }
                            Text("$59.99 / year ($4.99 / mo)")
                                .font(.system(size: 13))
                                .foregroundStyle(Color.auraTextSecondary)
                        }
                        Spacer()
                        Image(systemName: isYearly ? "checkmark.circle.fill" : "circle")
                            .font(.system(size: 22))
                            .foregroundStyle(isYearly ? Color.auraAmber : Color.auraTextMuted)
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 18)
                            .fill(Color.auraCard)
                            .overlay(RoundedRectangle(cornerRadius: 18).stroke(isYearly ? Color.auraAmber : Color.auraBorder, lineWidth: isYearly ? 1.5 : 0.8))
                    )
                }
                .buttonStyle(.plain)
                
                // Weekly Option
                Button {
                    AuraHaptic.selection()
                    isYearly = false
                } label: {
                    HStack {
                        VStack(alignment: .leading, spacing: 3) {
                            Text("Weekly Plan")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundStyle(.white)
                            Text("$5.99 / week")
                                .font(.system(size: 13))
                                .foregroundStyle(Color.auraTextSecondary)
                        }
                        Spacer()
                        Image(systemName: !isYearly ? "checkmark.circle.fill" : "circle")
                            .font(.system(size: 22))
                            .foregroundStyle(!isYearly ? Color.auraAmber : Color.auraTextMuted)
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 18)
                            .fill(Color.auraCard)
                            .overlay(RoundedRectangle(cornerRadius: 18).stroke(!isYearly ? Color.auraAmber : Color.auraBorder, lineWidth: !isYearly ? 1.5 : 0.8))
                    )
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 20)
            
            Spacer()
            
            // CTA Button
            Button {
                AuraHaptic.medium()
                onComplete()
            } label: {
                Text(isYearly ? "Start 3-Day Free Trial" : "Continue")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Capsule().fill(Color.auraAmber))
                    .shadow(color: Color.auraAmber.opacity(0.4), radius: 12, y: 4)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 8)
            
            Text("Cancel anytime in App Store. No commitment.")
                .font(.system(size: 11))
                .foregroundStyle(Color.auraTextMuted)
                .padding(.bottom, 16)
        }
    }
}
