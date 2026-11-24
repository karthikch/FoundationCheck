//
//  HomeScreen.swift
//  FoundationCheck
//
//  Created by karthik kumar Choppavarapu on 22/11/26.
//

import SwiftUI

struct HomeScreen: View {
    @State private var shouldNavigate = false

    var body: some View {
        
        NavigationStack
        {
            VStack(spacing: 10) {
                NavigationLink("Recipe Check") {
                    PromptView<RecipeModel>(instructions: """
    You are a cooking assistant. You suggest good recipes based on
    the user ask. Keep suggestions realistic
    for a home kitchen.
    """, navTitle: "Recipe Check")
                }
                .buttonStyle(.borderedProminent)
                NavigationLink("Weather Check") {
                    PromptView<WeatherModel>(instructions: """
You are a helpful, concise weather assistant. Extract accurate weather details from the provided text.
""", navTitle: "Weather Check")
                }
                .buttonStyle(.borderedProminent)
                NavigationLink("Travel Check") {
                    PromptView<TravelModel>(instructions: """
                                            You are an expert, practical travel planner.
                                            """, navTitle: "Travel Check")
                }
                .buttonStyle(.borderedProminent)
            }
            .navigationTitle("Home")
            Spacer()
        }
        
    }
}

#Preview {
    HomeScreen()
}
