//
//  SettingsRepository.swift
//  WeatherApp
//
//  Created by Guillaume Fleury on 2025/06/22.
//

import Foundation

class SettingsRepository: SettingsRepositoryProtocol {
    private let defaults = UserDefaults.standard

    private enum Keys {
        static let hasSeenLocationExplanation = "hasSeenLocationExplanation"
    }

    var hasSeenLocationExplanation: Bool {
        get {
            defaults.bool(forKey: Keys.hasSeenLocationExplanation.description)
        } set {
            defaults.set(newValue, forKey: Keys.hasSeenLocationExplanation.description)
        }
    }
}
