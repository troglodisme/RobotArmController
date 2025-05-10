//
//  CubeView.swift
//  RobotArmController
//
//  Created by Giulio on 23/09/24.
//


import RealityKit
import RealityKitContent
import SwiftUI

struct ImmersiveSpaceView: View {
    
    @State private var box = ModelEntity()
    @State private var isJumping = false
    @State private var scene: Entity? // Store the scene entity here
    
    var body: some View {
        VStack {
            
            HStack{
                Button(action: {
                    applyTransformToArm()
                }) {
                    Text("Rotate")
                        .font(.largeTitle)
                        .padding(100)
                    
                }
                .padding()
                Button(action: {
                    applyTransformToWrist_Right()
                }) {
                    Text("Right")
                        .font(.largeTitle)
                        .padding(100)
                    
                }
                .padding()
                
                Button(action: {
                    applyTransformToWrist_Left()
                }) {
                    Text("Left")
                        .font(.largeTitle)
                        .padding(100)
                    
                }
                .padding()
                
                
                Button(action: {
                    applyTransformToArm3()
                }) {
                    Text("Rotate")
                        .font(.largeTitle)
                        .padding(100)
                }
                .padding()
            }
 
            
            RealityView { content in
                
                if let loadedScene = try? await Entity(named: "Scene", in: realityKitContentBundle) {
                    loadedScene.transform.translation = [0, 0, -2] // Place 2 meters in front of the viewer
                    content.add(loadedScene)
                    print("Loaded Scene")
                    
                    // Store the scene in the @State variable
                    scene = loadedScene
                    
                    if let robotArm = loadedScene.findEntity(named: "RobotArm") {
                        print("Found RobotArm")
                        robotArm.components.set(InputTargetComponent(allowedInputTypes: .indirect))
                        robotArm.generateCollisionShapes(recursive: true)
                        robotArm.components.set(GroundingShadowComponent(castsShadow: true))

                        
                        if let base = robotArm.findEntity(named: "Base") {
                            print("> Found Base")
                            
                            if let arm1 = base.findEntity(named: "Arm_1") {
                                print("> Found Arm_1")
                                
                                // Now, search for Arm_1_Pivot inside Arm_1
                                if let arm1Pivot = arm1.findEntity(named: "Arm_1_Pivot") {
                                    print("> Found Arm_1_Pivot")
                                } else {
                                    print("> Arm_1_Pivot not found inside Arm_1")
                                }
                            } else {
                                print("> Arm_1 not found inside Base")
                            }
                            
                            
                            if let arm2 = base.findEntity(named: "Arm_2") {
                                print("> Found Arm_1")
                                
                                // Now, search for Arm_2_Pivot inside Arm_2
                                if let arm2Pivot = arm2.findEntity(named: "Arm_2_Pivot") {
                                    print("> Found Arm_2_Pivot")
                                } else {
                                    print("> Arm_2_Pivot not found inside Arm_2")
                                }
                            } else {
                                print("> Arm_2 not found inside Base")
                            }
                        }
                    }
                }
                
                //                let boxMesh = MeshResource.generateBox(size: 0.3)
                //                let material = SimpleMaterial(color: .red, isMetallic: true)
                //                box = ModelEntity(mesh: boxMesh, materials: [material])
                //                box.components.set(InputTargetComponent(allowedInputTypes: .indirect))
                //                box.generateCollisionShapes(recursive: true)
                //                box.components.set(GroundingShadowComponent(castsShadow: true))
                //
                //                box.transform.translation = [0, 0, -3] // Move the box 2 meters in front of the viewer
                //                content.add(box)
            }
            //            .gesture(
            //                DragGesture()
            //                    .targetedToEntity(box)
            //                    .onChanged({ value in
            //                        box.position = value.convert(
            //                            value.location3D, from: .local, to: box.parent!)
            //                    })
            //            )
            
        }
    }
    
    // Function to handle the jump action
    func jumpBox() {
        let initialPosition = box.position
        
        let jumpHeight: Float = 0.5
        
        // Move up
        box.move(to: Transform(translation: [initialPosition.x, initialPosition.y + jumpHeight, initialPosition.z]), relativeTo: box.parent!, duration: 0.3)
        
        // Move back down after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            box.move(to: Transform(translation: initialPosition), relativeTo: box.parent!, duration: 0.3)
        }
    }
    
    // Updated applyTransformToArm function
    func applyTransformToArm() {
        guard let scene = scene else {
            print("Scene is not loaded yet")
            return
        }
        
        if let armEntity = scene.findEntity(named: "Arm_1") {
            print("Found Arm_1")
            
            // Apply a transform - for example, rotation around the y-axis
            var newTransform = armEntity.transform
            newTransform.rotation = simd_quatf(angle: .pi / 4, axis: [0, 0, 1]) // 45 degrees rotation
            
            armEntity.move(to: newTransform, relativeTo: armEntity, duration: 1.0)
        } else {
            print("Arm_1 entity not found")
        }
    }
    
    func applyTransformToWrist_Right() {
        guard let scene = scene else {
            print("Scene is not loaded yet")
            return
        }
        
        if let wristEntity = scene.findEntity(named: "Wrist") {
            print("found Wrist")
            
            // Apply a transform - for example, rotation around the y-axis
            var newTransform = wristEntity.transform
            newTransform.rotation = simd_quatf(angle: .pi / 8, axis: [0, 0, 1]) // 45 degrees rotation
            
            wristEntity.move(to: newTransform, relativeTo: wristEntity, duration: 0.2)
        } else {
            print("Arm_1 entity not found")
        }
    }
    
    func applyTransformToWrist_Left() {
        guard let scene = scene else {
            print("Scene is not loaded yet")
            return
        }
        
        if let wristEntity = scene.findEntity(named: "Wrist") {
            print("found Wrist")
            
            // Apply a transform - for example, rotation around the y-axis
            var newTransform = wristEntity.transform
            newTransform.rotation = simd_quatf(angle: -.pi / 8, axis: [0, 0, 1]) // 45 degrees rotation
            
            wristEntity.move(to: newTransform, relativeTo: wristEntity, duration: 0.2)
        } else {
            print("Arm_1 entity not found")
        }
    }
    
    func applyTransformToArm3() {
        guard let scene = scene else {
            print("Scene is not loaded yet")
            return
        }

        // Create an anchor entity as the pivot point
        let anchorEntity = AnchorEntity(world: [0, 2, 0]) // Position it at the desired pivot point
        anchorEntity.name = "RotationAnchor"
        
        // Add a visible sphere to the anchor to visualize its position
        let anchorSphere = ModelEntity(mesh: MeshResource.generateSphere(radius: 0.05), materials: [SimpleMaterial(color: .green, isMetallic: true)])
        anchorEntity.addChild(anchorSphere)
        
        // Add the anchor to the scene
        scene.addChild(anchorEntity)
        
        // Find Arm_1
        if let arm1Entity = scene.findEntity(named: "Arm_1") {
            print("Found Arm_1")
            
            // Make Arm_1 a child of the anchor entity
            anchorEntity.addChild(arm1Entity)
            
            // Start a timer to rotate manually
            let rotationSpeed: Float = .pi / 100.0 // Small incremental angle (radians)
            var currentAngle: Float = 0.0
            
            // Compensate for the initial 90 degrees rotation on the X-axis
            let initialRotationQuat = simd_quatf(angle: .pi / 2, axis: [1, 0, 0]) // 90 degrees on X-axis
            
            // Create a timer to manually rotate the arm
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                // Increment the rotation angle
                currentAngle += rotationSpeed
                
                // Create a new rotation quaternion for the Y-axis
                let yRotationQuat = simd_quatf(angle: currentAngle, axis: [0, 1, 0]) // Rotate around Y-axis
                
                // Combine the initial X-axis rotation with the new Y-axis rotation
                let combinedRotation = yRotationQuat * initialRotationQuat
                
                // Update the anchor's rotation
                anchorEntity.transform.rotation = combinedRotation
                
                // Stop the timer after a full rotation (2π radians)
                if currentAngle >= 2 * .pi {
                    timer.invalidate() // Stop the timer
                }
            }
            
        } else {
            print("Arm_1 entity not found")
        }
    }

    
    






    
    
}


#Preview {
    ImmersiveSpaceView()
}




//if let model = try? await Entity(named: "LandingGear", in: realityKitContentBundle){
//    GearRealityView.modelEntity = model
//
//    // Choose a collision shape which fits the bounds of the object.
//    // You can also create a CollisionComponent in Reality Composer Pro instead of at runtime.
//    let collisionShape = ShapeResource.generateSphere(radius: 0.25)
//
//    model.components.set([
//        CollisionComponent(shapes: [collisionShape]),
//        InputTargetComponent()
//    ])
//    content.add(model)
//}
