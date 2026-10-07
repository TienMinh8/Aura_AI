import SwiftUI
import SwiftData
import UserNotifications

@main
struct AuraApp: App {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = true
    
    let sharedModelContainer: ModelContainer
    
    init() {
        // Register UNUserNotificationCenter delegate
        UNUserNotificationCenter.current().delegate = NotificationDelegate.shared
        
        do {
            let schema = Schema([
                AuraEvent.self,
                ChatMessage.self,
                Routine.self,
                UserProfile.self,
                ConnectedApp.self,
                Habit.self,
                UserMemory.self,
                GoalPlan.self,
                GoalStep.self
            ])
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            self.sharedModelContainer = container
            
            // Seed initial data if necessary
            Task { @MainActor in
                Self.seedInitialDataIfNeeded(context: container.mainContext)
            }
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                if hasCompletedOnboarding {
                    MainTabView()
                } else {
                    OnboardingView {
                        hasCompletedOnboarding = true
                    }
                }
            }
            .modelContainer(sharedModelContainer)
            .environment(PermissionsManager.shared)
        }
    }
    
    @MainActor
    private static func seedInitialDataIfNeeded(context: ModelContext) {
        // Seed Routines
        let routineDescriptor = FetchDescriptor<Routine>()
        let existingRoutines = (try? context.fetch(routineDescriptor)) ?? []
        if existingRoutines.isEmpty {
            for r in Routine.defaultRoutines {
                context.insert(r)
                NotificationService.shared.scheduleRoutine(for: r)
            }
        }
        
        // Seed UserProfile
        let profileDescriptor = FetchDescriptor<UserProfile>()
        let existingProfiles = (try? context.fetch(profileDescriptor)) ?? []
        if existingProfiles.isEmpty {
            context.insert(UserProfile())
        }
        
        // Seed ConnectedApps
        let appsDescriptor = FetchDescriptor<ConnectedApp>()
        let existingApps = (try? context.fetch(appsDescriptor)) ?? []
        if existingApps.isEmpty {
            for app in ConnectedApp.defaultApps {
                context.insert(app)
            }
        }
        
        // Seed Initial Events if empty
        let eventsDescriptor = FetchDescriptor<AuraEvent>()
        let existingEvents = (try? context.fetch(eventsDescriptor)) ?? []
        if existingEvents.isEmpty {
            for ev in AuraEvent.samples {
                context.insert(ev)
                NotificationService.shared.scheduleEventReminder(for: ev)
            }
        }
        
        // Seed initial Chat messages if empty
        let chatDescriptor = FetchDescriptor<ChatMessage>()
        let existingChats = (try? context.fetch(chatDescriptor)) ?? []
        if existingChats.isEmpty {
            for msg in ChatMessage.samples {
                context.insert(msg)
            }
        }
        
        // Seed Habits if empty
        let habitDescriptor = FetchDescriptor<Habit>()
        let existingHabits = (try? context.fetch(habitDescriptor)) ?? []
        if existingHabits.isEmpty {
            for habit in Habit.defaults {
                context.insert(habit)
            }
        }
        
        // Seed UserMemories if empty
        let memoryDescriptor = FetchDescriptor<UserMemory>()
        let existingMemories = (try? context.fetch(memoryDescriptor)) ?? []
        if existingMemories.isEmpty {
            for mem in UserMemory.defaults {
                context.insert(mem)
            }
        }
        
        // Seed GoalPlans if empty
        let goalDescriptor = FetchDescriptor<GoalPlan>()
        let existingGoals = (try? context.fetch(goalDescriptor)) ?? []
        if existingGoals.isEmpty {
            for goal in GoalPlan.defaults {
                context.insert(goal)
            }
        }
        
        try? context.save()
    }
}
