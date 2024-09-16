//
//  MealModel.swift
//  ChefDaily
//
//  Created by Ruben de Koning on 16/09/2024.
//

import Foundation

struct MealResponse: Codable {
    let meals: [Meal]?
}

struct Meal: Identifiable, Codable {
    var id: String { idMeal }
    let idMeal: String
    let strMeal: String
    let strCategory: String?
    let strInstructions: String?
    let strMealThumb: String?
}
