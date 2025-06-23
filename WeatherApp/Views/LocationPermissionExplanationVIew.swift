//
//  LocationPermissionExplanationVIew.swift
//  WeatherApp
//
//  Created by Guillaume Fleury on 2025/06/21.
//

import Foundation
import SwiftUI

struct LocationPermissionExplanationView: View {
    var onAllow: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "location.circle")
                .font(.system(size: 64))
                .foregroundColor(.blue)

            Text(Strings.LocationPermissionExplanation.enableLocation)
                .font(.title)
                .bold()

            Text(Strings.LocationPermissionExplanation.description)
                .multilineTextAlignment(.center)

            Button(Strings.LocationPermissionExplanation.allowLocation) {
                onAllow()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}
