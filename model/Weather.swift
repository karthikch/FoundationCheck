//
//  Weather.swift
//  FoundationCheck
//
//  Created by karthik kumar Choppavarapu on 23/11/26.
//

import Foundation
import FoundationModels

@Generable(description: "Structured weather forecast and conditions")
struct WeatherModel {
       @Guide(description: "The name of the city or location")
       var location: String

       @Guide(description: "Current temperature in Celsius", .range(-60...60))
       var temperatureCelsius: Int

       @Guide(description: "Sky condition summary")
       var condition: WeatherCondition

       @Guide(description: "Humidity percentage from 0 to 100", .range(0...100))
       var humidityPercent: Int

       @Guide(description: "A brief, one-sentence outfit or activity recommendation")
       var advice: String
}

@Generable
enum WeatherCondition: String, CaseIterable {
    case sunny
    case partlyCloudy
    case cloudy
    case rainy
    case stormy
    case snowy
}
