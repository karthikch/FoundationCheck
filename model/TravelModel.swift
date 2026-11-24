//
//  TravelModel.swift
//  FoundationCheck
//
//  Created by karthik kumar Choppavarapu on 23/11/26.
//

import Foundation
import FoundationModels

@Generable
struct TravelModel {
    @Guide(description: "Destination city and country, e.g. 'Kyoto, Japan'")
    var destination: String

    @Guide(description: "Total trip duration in days", .range(1...14))
    var durationDays: Int

    @Guide(description: "Best time or season to visit, e.g. 'October to November'")
    var bestTimeToVisit: String

    @Guide(description: "Estimated budget category: Budget, Moderate, or Luxury")
    var budgetLevel: BudgetTier

    @Guide(description: "Top 3 to 5 must-visit attractions or landmarks", .maximumCount(5))
    var topAttractions: [String]

    @Guide(description: "Day-by-day itinerary highlights", .maximumCount(5))
    var itinerary: [DayPlan]

    @Guide(description: "Practical local travel tips, transit advice, or etiquette")
    var travelTips: String
}

@Generable
enum BudgetTier: String, CaseIterable {
    case budget = "Budget"
    case moderate = "Moderate"
    case luxury = "Luxury"
}

@Generable
struct DayPlan {
    @Guide(description: "Day number starting at 1")
    var day: Int

    @Guide(description: "Short theme or title for the day")
    var theme: String

    @Guide(description: "Key activities planned for the day", .maximumCount(4))
    var activities: [String]
}


extension TravelModel.PartiallyGenerated: StreamDisplayable {
    var formattedSummary: String {
        let title = destination ?? ""
        let days = durationDays.map { "\($0) Days" } ?? ""
        let tier = budgetLevel?.rawValue ?? ""
        let header = [title, days, tier].filter { !$0.isEmpty }.joined(separator: " • ")

        let attractionsText = (topAttractions ?? [])
            .map { "• \($0)" }
            .joined(separator: "\n")

        let itineraryText = (itinerary ?? [])
            .map { plan in
                let dayNum = plan.day.map { "Day \($0): " } ?? ""
                let theme = plan.theme ?? ""
                let acts = (plan.activities ?? []).joined(separator: ", ")
                return "\(dayNum)\(theme)\n  \(acts)"
            }
            .joined(separator: "\n")

        let tips = travelTips ?? ""

        return [
            header,
            attractionsText.isEmpty ? "" : "Top Attractions:\n\(attractionsText)",
            itineraryText.isEmpty ? "" : "Itinerary:\n\(itineraryText)",
            tips.isEmpty ? "" : "Tips: \(tips)"
        ]
        .filter { !$0.isEmpty }
        .joined(separator: "\n\n")
    }
}
