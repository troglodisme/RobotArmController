//
//  CubeView 2.swift
//  RobotArmController
//
//  Created by Giulio on 23/09/24.
//

import SwiftUI
import RealityKit

struct RobotArmView: View {
    
    @State private var angle: Angle = .degrees(0)
    @State private var angle2: Angle = .degrees(90)

    var body: some View {
    
        VStack(spacing: 18.0) {
            Model3D(named: "RobotArm") { model in
                switch model {
                case .empty:
                    ProgressView()
                    
                case .success(let resolvedModel3D):
                    resolvedModel3D
                        .scaleEffect(0.2)
                        .rotation3DEffect(angle2, axis: .x)
                        .rotation3DEffect(angle, axis: .y)
                        .animation(.linear(duration: 18).repeatForever(), value: angle)
                        .onAppear {
                            angle = .degrees(359)
                        }
                        
                case .failure(let error):
                    Text(error.localizedDescription)
                    
                @unknown default:
                    EmptyView()
                }
            }
        }
        
        
    }
}

#Preview {
    RobotArmView()
}
