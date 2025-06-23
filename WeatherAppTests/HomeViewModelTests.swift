//
//  HomeViewModelTests.swift
//  WeatherAppTests
//
//  Created by Guillaume Fleury on 2025/06/22.
//

import XCTest
import CoreLocation
@testable import WeatherApp

// TODO: 本来であればモックライブラリ（例：Cuckooなど）を使ってテストを実装すべきですが、今回は時間の都合により省略します。
final class HomeViewModelTests: XCTestCase {
    var viewModel: HomeViewModel!
    var mockWeatherRepository: MockWeatherRepository!
    var mockSettingsRepository: MockSettingsRepository!
    var mockLocationManager: MockLocationManager!

    override func setUp() {
        super.setUp()
        mockWeatherRepository = MockWeatherRepository()
        mockSettingsRepository = MockSettingsRepository()
        mockLocationManager = MockLocationManager()
        viewModel = HomeViewModel(weatherRepository: mockWeatherRepository, settingsRepository: mockSettingsRepository!, locationManager: mockLocationManager!)
    }

    // MARK: permission
    func testShowLocationPermission() async {
        // Arrange
        mockLocationManager.isAuthorized = false
        mockSettingsRepository.hasSeenLocationExplanationResult = false

        // Act
        await viewModel.checkLocationPermission()
        
        // location説明画面を表示
        XCTAssert(viewModel.showLocationPermissionExplanation == true)
    }
    
    func testDoNotShowLocationPermission() async {
        // Arrange
        mockLocationManager.isAuthorized = false
        mockSettingsRepository.hasSeenLocationExplanationResult = true

        // Act
        await viewModel.checkLocationPermission()
        
        // location説明画面を表示しない
        XCTAssert(viewModel.showLocationPermissionExplanation == false)
    }

    func testSetCurrentLocation() async {
        let currentLocation = CLLocation(latitude: Constants.DefaultFavoriteLocations.all[0].lat, longitude: Constants.DefaultFavoriteLocations.all[0].lon)
        // Arrange
        mockLocationManager.isAuthorized = true
        mockLocationManager.currentLocation = currentLocation
        mockSettingsRepository.hasSeenLocationExplanationResult = true

        // Act
        await viewModel.checkLocationPermission()
        
        // currentWeatherLocationは設定されたこと
        XCTAssert(viewModel.currentWeatherLocation?.lat == currentLocation.coordinate.latitude)
        XCTAssert(viewModel.currentWeatherLocation?.lon == currentLocation.coordinate.longitude)
    }
}
