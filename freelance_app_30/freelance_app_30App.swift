import SwiftUI
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct freelance_app_30App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var sharedData = SharedData()
    @State private var showPreloader = true
    @State private var isFirstLaunch = !UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
    @State private var hasStarted = UserDefaults.standard.bool(forKey: "hasStarted")
    
    var body: some Scene {
        WindowGroup {
            if showPreloader {
                PreloaderScreen()
                    .preferredColorScheme(.dark)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation {
                                showPreloader = false
                                if isFirstLaunch {
                                    UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
                                }
                            }
                        }
                    }
            } else {
                Group {
                    if isFirstLaunch || !hasStarted {
                        OnboardingScreen(viewModel: OnboardingViewModel())
                    } else {
                        MainScreen(viewModel: MainViewModel())
                    }
                }
                .environmentObject(sharedData)
                .preferredColorScheme(.dark)
            }
        }
    }
}


#Preview {
    OnboardingScreen(viewModel: OnboardingViewModel())
}
