//
//  RealityView.swift
//  RobotArmController
//
//  Created by Giulio on 23/09/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct VolumeView: View {
    
    var body: some View {

            RealityView { content in
                
                if let scene = try? await Entity(named: "Scene", in: realityKitContentBundle) {
                    content.add(scene)
                    
//                    if let robotArm = scene.findEntity(named: "RobotArm") {
//                        print("Found RobotArm, applying scale")
//
//                        if let base = robotArm.findEntity(named: "Base") {
//                            print("Found Base")
//                            
//                            if base.findEntity(named: "Arm_1") != nil {
//                                print("Found Arm_1")
//                                
//                                //How can I apply rotation
//                                
//                            } else {
//                                print("Arm_1 not found")
//                            }
//                            
//                        } else {
//                            print("Base not found")
//                        }
//
//                    } else {
//                        print("RobotArm not found")
//                    }
     
                }
            }
        }
    }


#Preview {
    VolumeView()
}
