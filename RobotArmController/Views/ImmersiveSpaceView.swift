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
    
    var body: some View {
        VStack {
            
            //temporary to test movement
            Button(action: {
                jumpBox()
            }) {
                Text("Jump")
                    .font(.largeTitle)
                    .padding(20)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(15)
            }
            .padding()
            
            RealityView { content in
                                
                if let scene = try? await Entity(named: "Scene", in: realityKitContentBundle) {
                    scene.transform.translation = [0, 0, -2] // Place 2 meters in front of the viewer
                    content.add(scene)
                    print("Loaded Scene")
                    
                    if let robotArm = scene.findEntity(named: "RobotArm") {
                        print("Found RobotArm")
                        robotArm.components.set(InputTargetComponent(allowedInputTypes: .indirect))
                        robotArm.generateCollisionShapes(recursive: true)
                        robotArm.components.set(GroundingShadowComponent(castsShadow: true))
                                            
                        
                        if let base = robotArm.findEntity(named: "Base") {
                            print("Found Base")
                            
                            if base.findEntity(named: "Arm_1") != nil {
                                print("Found Arm_1")
                            }
                        }
                    }
                    
                }
                
                let boxMesh = MeshResource.generateBox(size: 0.3)
                let material = SimpleMaterial(color: .red, isMetallic: true)
                box = ModelEntity(mesh: boxMesh, materials: [material])
                box.components.set(InputTargetComponent(allowedInputTypes: .indirect))
                box.generateCollisionShapes(recursive: true)
                box.components.set(GroundingShadowComponent(castsShadow: true))
                
                box.transform.translation = [0, 0, -3] // Move the box 2 meters in front of the viewer
                content.add(box)
            }
            .gesture(
                DragGesture()
                    .targetedToEntity(box)
                    .onChanged({ value in
                        box.position = value.convert(
                            value.location3D, from: .local, to: box.parent!)
                    })
            )
            
            
        
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
