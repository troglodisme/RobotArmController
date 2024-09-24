//
//  SecondaryVolumeView.swift
//  RobotArmController
//
//  Created by Giulio on 23/09/24.
//


import SwiftUI

struct SecondaryVolumeView: View {
    
    @Environment(ViewModel.self) private var model
    
    var body: some View {
    
        ZStack(alignment: .bottom) {
//            RobotArmView()
            VolumeView()
//            ImmsersiveViewTest()
            
            Text("This is a volume")
                .padding()
                .glassBackgroundEffect(in: .capsule)
        }
        .onDisappear {
            model.secondaryVolumeIsShowing.toggle()
        }
        
    }
}

#Preview {
    SecondaryVolumeView()
        .environment(ViewModel())
}
