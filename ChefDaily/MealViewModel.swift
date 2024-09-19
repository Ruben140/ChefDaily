//
//  MealViewModel.swift
//  ChefDaily
//
//  Created by Ruben de Koning on 16/09/2024.
//

import Foundation
import Combine

class MealViewModel: ObservableObject {
    @Published var meals: [Meal] = []
    @Published var searchQuery: String = ""
    
    // Default values for filters, matching valid picker options
    @Published var selectedCategory: String = "Seafood" // Example default category
    @Published var selectedArea: String = "Italian"    // Example default area
    @Published var selectedIngredient: String = "Chicken" // Example default ingredient
    
    private var mealService = MealService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // Trigger search whenever search query or filters change
        Publishers.CombineLatest3($searchQuery, $selectedCategory, $selectedArea)
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] searchQuery, category, area in
                self?.fetchMeals(searchQuery: searchQuery)
            }
            .store(in: &cancellables)
    }
    
    func fetchMeals(searchQuery: String) {
        let filter = MealFilter(category: selectedCategory, area: selectedArea, ingredient: selectedIngredient)
        
        mealService.fetchMeals(searchQuery: searchQuery, filter: filter) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let meals):
                    self.meals = meals
                case .failure(let error):
                    print("Error fetching meals: \(error)")
                    self.meals = []
                }
            }
        }
    }
}
