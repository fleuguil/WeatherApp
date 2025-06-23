//
//  HomeViewModel.swift
//  WeatherApp
//
//  Created by Guillaume Fleury on 2025/06/19.
//

import Foundation

/// TODO: DocCのコメントをしっかり書く

/// HomeViewModel
/// ホーム画面
/// お気に入り管理、現在地、current天気、検索の管理
@Observable
final class HomeViewModel {
    // search
    var isSearching: Bool = false
    var searchQuery: String = ""
    var searchResults: [WeatherLocation] = []
    private var searchTask: Task<Void, Never>?
    // generic
    var errorMessage: String? = nil
    private let locationManager: LocationManagerProtocol
    var showLocationPermissionExplanation = false
    
    var favorites = Constants.DefaultFavoriteLocations.all
    // will become non-nil once we get info
    var currentWeatherLocation: WeatherLocation? = nil
    
    private let weatherRepository: WeatherRepositoryProtocol
    private var settingsRepository: SettingsRepositoryProtocol
    
    init(weatherRepository: WeatherRepositoryProtocol, settingsRepository: SettingsRepositoryProtocol, locationManager: LocationManagerProtocol) {
        self.weatherRepository = weatherRepository
        self.settingsRepository = settingsRepository
        self.locationManager = locationManager
    }
    
    /// 位置情報のpermissionsをチェック。必要なら説明画面を表示、現在地の位置情報を取得など
    func checkLocationPermission() async {
        // 一回のみ表示
        if !locationManager.isAuthorized && !settingsRepository.hasSeenLocationExplanation {
            showLocationPermissionExplanation = true
        } else if locationManager.isAuthorized {
            // get current location
            if let currentLocation = try? await locationManager.currentLocation {
                if let currentWeather = try? await weatherRepository.fetchCurrentWeather(for: currentLocation.coordinate.latitude, lon: currentLocation.coordinate.longitude) {
                    var currentWeatherLocation = WeatherLocation(names: [Locale.current.language.languageCode?.identifier ?? Config.defaultLocale: currentWeather.name], lat: currentLocation.coordinate.latitude, lon: currentLocation.coordinate.longitude)
                    currentWeatherLocation.currentWeather = currentWeather
                    self.currentWeatherLocation = currentWeatherLocation
                } else {
                    // 無視する
                }
            }
        } else {
            // we don't have permission, can't do anything, will show error if user tries to select current location
        }
    }
        
    /// ユーザーに位置情報許可を求める
    func requestLocationPermission() async {
        // never show again
        settingsRepository.hasSeenLocationExplanation = true
        // will wait until user responds
        let _ = await locationManager.requestAuthorization()
        showLocationPermissionExplanation = false
        // if we got permission, will set currentWeatherLocation
        await checkLocationPermission()
    }
      
    /// 現在地詳細天気予報に遷移
    func triedToNavigateToCurrentLocation() {
        if currentWeatherLocation == nil {
            errorMessage = Strings.Home.locationDenied
        }
    }
        
    /// お気に入り、現在地の現在天気情報を取得
    func getCurrentWeather() async {
        // fetch current weather for each favorite
        var updatedFavorites = favorites
            
        // would be better to load in parallel but we keep it simple for now
        for index in updatedFavorites.indices {
            do {
                let currentWeather = try await weatherRepository.fetchCurrentWeather(for: updatedFavorites[index].lat, lon: updatedFavorites[index].lon)
                updatedFavorites[index].currentWeather = currentWeather
            } catch {
                // 無視する                
            }
        }
        // update UI (just once to avoid too many refreshes)
        favorites = updatedFavorites
    }
    
    /// 検索を行い
    func performSearch() {
        searchTask?.cancel()
        
        searchTask = Task {
            guard !Task.isCancelled else { return }
            do {
                searchResults = try await weatherRepository.searchLocations(query: searchQuery)
            } catch {
                if Task.isCancelled { return }
                // 細かいエラーは表示しない
                errorMessage = Strings.Error.failedSearch
                searchResults = []
            }
        }
    }
    
    /// 検索をキャンセル(searchBarがdismissされたなど)
    func cancelSearch() {
        searchTask?.cancel()
        searchQuery = ""
        searchResults = []
        isSearching = false
    }
    
    // reset state
    func reset() {
        errorMessage = nil
    }
}
