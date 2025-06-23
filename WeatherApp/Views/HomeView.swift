//
//  HomeView.swift
//  WeatherApp
//
//  Created by Guillaume Fleury on 2025/06/19.
//

import SwiftUI

struct HomeView: View {
    @State var viewModel: HomeViewModel
    @State private var selectedFavorite: WeatherLocation?
    
    init() {
        // TODO: WeatherRepositoryをDI?
        self._viewModel = State(initialValue: HomeViewModel(weatherRepository: WeatherRepository(apiKey: Config.apiKey), settingsRepository: SettingsRepository(), locationManager: LocationManager()))
    }
    
    var body: some View {
        NavigationStack() {
            List {
                if viewModel.isSearching {
                    ForEach(viewModel.searchResults, id: \.self) { location in
                        NavigationLink(value: location) {
                            Text(location.names?[Locale.current.language.languageCode?.identifier ?? Config.defaultLocale] ?? Strings.notAvailable)
                                .font(.headline)
                        }
                    }
                } else {
                    ForEach(viewModel.favorites, id: \.self) { favorite in
                        Button {
                            selectedFavorite = favorite
                        } label: {
                            WeatherLocationCardView(weatherLocation: favorite)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    // current location
                    Button {
                        // if we don't have a current location, something is wrong...
                        if viewModel.currentWeatherLocation == nil {
                            // show error
                            viewModel.triedToNavigateToCurrentLocation()
                        } else {
                            selectedFavorite = viewModel.currentWeatherLocation
                        }
                    } label: {
                        WeatherLocationCardView(weatherLocation: viewModel.currentWeatherLocation)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .navigationDestination(item: $selectedFavorite) { favorite in
                WeatherView(weatherLocation: favorite)
            }
            .navigationDestination(for: WeatherLocation.self) { location in
                WeatherView(weatherLocation: location)
            }
            .navigationTitle(Strings.Home.title)
            .navigationBarTitleDisplayMode(.large)
        }        
        .alert(Strings.error, isPresented: .init(
            get: { viewModel.errorMessage != nil },
            set: { newValue in
                if !newValue { viewModel.reset() }
            }
        )) {
            Button(Strings.ok, role: .cancel) {
                viewModel.reset()
            }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
        .sheet(isPresented: $viewModel.showLocationPermissionExplanation) {
            LocationPermissionExplanationView {
                Task {
                    await viewModel.requestLocationPermission()
                }
            }
        }
        .onAppear {
            // TaskはVMで作成したほうがよいか。
            Task {
                await viewModel.checkLocationPermission()
                await viewModel.getCurrentWeather()
            }
        }
        .searchable(text: $viewModel.searchQuery, isPresented: $viewModel.isSearching, prompt: Strings.Home.searchPlaceholder)
        .onSubmit(of: .search) {
            viewModel.performSearch()
        }
        .onChange(of: viewModel.searchQuery) { old, new in
            if new.isEmpty {
                viewModel.cancelSearch()
            }
        }
    }
}


#Preview {
    HomeView()
}
