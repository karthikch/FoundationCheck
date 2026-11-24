//
//  Recipe.swift
//  FoundationCheck
//
//  Created by karthik kumar Choppavarapu on 22/11/26.
//

import Foundation
import FoundationModels

@Generable
struct RecipeModel
{
    @Guide(description: "The name of the dish.")
    let title: String;
    
    @Guide(description: "Ingredients with quantities, one per line.")
    @Guide(.count(3...8))
    let ingredients: [String];
    
    @Guide(description: "Step-by-step cooking instructions.")
    let procedure: [String];
}
