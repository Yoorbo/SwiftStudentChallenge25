//
//  LargeRoundButtonStyle.swift
//  HealthyTrack
//
//  Created by Yann Berton on 04.02.25.
//

import SwiftUI


struct LargeRoundButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
			.font(.largeTitle.bold())
            .frame(width: 80, height: 80)
            .background(.thinMaterial)
            .clipShape(Circle())
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}


struct SmallRoundButtonStyle: ButtonStyle {
	func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.font(.title3)
			.fontWeight(.semibold)
			.frame(width: 50, height: 50)
			.foregroundStyle(.white)
			.background(.tint)
			.clipShape(Circle())
			.scaleEffect(configuration.isPressed ? 0.95 : 1.0)
			.animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
	}
}
