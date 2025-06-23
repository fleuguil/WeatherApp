//
//  WeatherView.swift
//  WeatherApp
//
//  Created by Guillaume Fleury on 2025/06/19.
//

import Foundation
import SwiftUI

struct WeatherView: View {
    // @Stateと@ObservableはOK
    // https://www.hackingwithswift.com/books/ios-swiftui/using-state-with-classes
    @State private var viewModel: WeatherViewModel
    
    let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "EEEE" // Full weekday name
        return formatter
    }()
    
    init(weatherLocation: WeatherLocation) {
        self._viewModel = State(initialValue: WeatherViewModel(weatherLocation: weatherLocation, repository: WeatherRepository(apiKey: Config.apiKey)))
    }
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                VStack {
                    ProgressView()
                    Text(Strings.Weather.loading)
                        .foregroundStyle(.secondary)
                        .padding(.top, 8)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            else if let error = viewModel.errorMessage {
                VStack(spacing: 16) {
                    Text(error)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                    Button(Strings.Weather.retry) {
                        Task {
                            await viewModel.fetch()
                        }
                    }
                }
                .padding()
            } else {
                // loading中はnavigationTitleを設定できないので、その代わりにTextにする
                Text(viewModel.locationName)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding([.top, .horizontal])
                
                List {
                    ForEach(viewModel.groupedByDateForecasts, id: \.0) { (day, forecastPeriods) in
                        Section(header: Text(dayFormatter.string(from: day))) {
                            ForEach(forecastPeriods, id: \.date) { forecastPeriod in
                                ForecastPeriodCardView(forecastPeriod: forecastPeriod)
                            }
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
        .task {
            if viewModel.forecast == nil {
                await viewModel.fetch()
            }
        }
    }
    
    // デバイスの時間帯にフォーマットする
    // TODO:
    // 仕様: list.dt は⽇本のタイムゾーンに合わせて表⽰する
    // 強制的に日本時間に変更する必要があるか→要確認
    //    private func formattedDate(_ date: Date) -> String {
    //        let formatter = DateFormatter()
    //        formatter.dateStyle = .medium
    //        formatter.timeStyle = .short
    //        return formatter.string(from: date)
    //    }
}

#Preview {
    WeatherView(weatherLocation: Constants.DefaultFavoriteLocations.all[0])
}
