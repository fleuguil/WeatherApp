//
//  WeatherInfoCardView.swift
//  WeatherApp
//
//  Created by Guillaume Fleury on 2025/06/22.
//

import Foundation
import SwiftUI

struct WeatherInfoCardView: View {
    let title: String
    let temperature: String
    let description: String
    let iconCode: String?

    var body: some View {

        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemGray6))
                .shadow(radius: 2)

            VStack(alignment: .leading) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(title)
                            .font(.headline)
                        
                        Spacer().frame(height: 16)
                        
                        Text(description)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    HStack(alignment: .center, spacing: 8) {
                        WeatherIconView(iconCode: iconCode)
                        
                        Text(temperature)
                            .font(.system(size: 32, weight: .bold))
                    }
                }
            }
            .padding()
            .background(Color("WeatherInfoBackground")) // デフォルトでアイコンが見えない場合がある
            .cornerRadius(16)
        }
        .frame(height: 70)
        .padding(.vertical, 4)
    }    
}

struct WeatherIconView: View {
    let iconCode: String?

    var body: some View {
        if let iconCode,
           let url = URL(string: "https://openweathermap.org/img/wn/\(iconCode)@2x.png") {
            // キャッシュされてない、外部ライブラリが必要
            AsyncImage(url: url) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 48, height: 48)
            } placeholder: {
                Color.clear.frame(width: 48, height: 48)
            }
        } else {
            Color.clear.frame(width: 48, height: 48)
        }
    }
}

#Preview {
    WeatherInfoCardView(title: "Tokyo", temperature: "30°", description: "sunny", iconCode: "01d")
}
