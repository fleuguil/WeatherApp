//
//  MockSettingsRepository.swift
//  WeatherAppTests
//
//  Created by Guillaume Fleury on 2025/06/22.
//

import Foundation
@testable import WeatherApp

final class MockSettingsRepository: SettingsRepositoryProtocol {
    private(set) var wasSetCalled = false

    var hasSeenLocationExplanation: Bool {
        get { hasSeenLocationExplanationResult }
        set {
            wasSetCalled = true
            hasSeenLocationExplanationResult = newValue
        }
    }

    var hasSeenLocationExplanationResult = false
}
