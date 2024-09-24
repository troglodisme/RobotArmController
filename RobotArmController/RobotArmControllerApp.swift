//
//  RobotArmControllerApp.swift
//  RobotArmController
//lean
//  Created by Giulio on 23/09/24.
//

import SwiftUI

//@main
//struct RobotArmControllerApp: App {
//    
//    @State private var model = ViewModel()
//    
//    var body: some Scene {
//    
//        WindowGroup {
//            PrimaryWindowView()
//                .environment(model)
//        }
//        
//        WindowGroup(id: "secondaryVolume") {
//            SecondaryVolumeView()
//                .environment(model)
//        }
//        .windowStyle(.volumetric)
//        .defaultSize(width: 1, height: 1, depth: 1, in: .meters)
//        
//    }
//}

@main
struct RobotArmControllerApp: App {

    var body: some Scene {
        WindowGroup() {
            ContentView()
        }


        // Definition of the Immersive Space.
        ImmersiveSpace(id: "MyImmersiveSpaceID") {
            ImmersiveSpaceView()
        }
    }
    
}

struct ContentView: View {

    @State private var isImmersiveSpaceOpened = false

    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace

    var body: some View {
        Button(isImmersiveSpaceOpened ? "Exit Immersive Space" : "Show Immersive Space", role: isImmersiveSpaceOpened ? .destructive : .none) {
            Task {
                if isImmersiveSpaceOpened {
                    await dismissImmersiveSpace()
                    isImmersiveSpaceOpened = false
                } else {
                    let result = await openImmersiveSpace(id: "MyImmersiveSpaceID")  // Corrected the ID
                    if result == .opened {
                        isImmersiveSpaceOpened = true
                    }
                }
            }
        }
    }
}
