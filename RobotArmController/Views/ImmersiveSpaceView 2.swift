
//
//  CubeView.swift
//  RobotArmController
//
//  Created by Giulio on 23/09/24.
//


import RealityKit
import RealityKitContent
import SwiftUI


struct ImmersiveSpaceView2: View {
    @State private var scene: Entity?
    @State private var robotArm: Entity?
    
    var body: some View {
        
        VStack {
            
            Button(action: {
                rotateArmPart(named: "Arm1", angle: 45)
            }) {
                Text("Rotate")
                    .font(.largeTitle)
                    .padding(100)
            }
            .keyboardShortcut("r") // Adds "R" key as a keyboard shortcut

                
            RealityView { content in
                // Load the scene from the USDZ file
                
                if let loadedScene = try? await Entity(named: "Scene", in: realityKitContentBundle) {
                    
                    // Add the loaded scene to the content
                    content.add(loadedScene)
                    print("Loaded Scene")
                    
                    // Store the loaded scene and robot arm reference
                    scene = loadedScene
                    if let robotArmEntity = loadedScene.findEntity(named: "RA") {
                        print("Found RA")
                        
                        robotArm = robotArmEntity
                        
                        robotArmEntity.transform.scale = [0.05, 0.05, 0.05]
                        
                        // Enable input interaction
                        robotArmEntity.components.set(InputTargetComponent(allowedInputTypes: .indirect))
                        robotArmEntity.generateCollisionShapes(recursive: true)
                        
                        // Set shadow casting for the robotic arm
                        robotArmEntity.components.set(GroundingShadowComponent(castsShadow: true))
                        
                        // Rotate the robotic arm parts
                        rotateArmPart(named: "Arm1", angle: 270)
                        rotateArmPart(named: "Arm2", angle: 30)
                    }
                }
            } // Closing RealityView
            .gesture(RotationGesture().onChanged { rotation in
                // Optional: Allow gesture-based rotation of the robot arm
                if let robotArm = robotArm {
                    robotArm.transform.rotation = simd_quatf(angle: Float(rotation.degrees), axis: [0, 1, 0])
                }
            })
        }
    }
    
    // Function to rotate a specific arm part
    func rotateArmPart(named partName: String, angle: Float) {
        guard let part = robotArm?.findEntity(named: partName) else {
            print("Could not find part: \(partName)")
            return
        }
        print("Rotating \(partName)")
        part.transform.rotation = simd_quatf(angle: angle * .pi / 180, axis: [0, 0, 1])
    }

}
