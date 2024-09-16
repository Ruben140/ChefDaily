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
    
    private var mealService = MealService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        $searchQuery
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] newQuery in
                self?.fetchMeals(searchQuery: newQuery)
            }
            .store(in: &cancellables)
    }
    
    func fetchMeals(searchQuery: String) {
        mealService.fetchMeals(searchQuery: searchQuery) { result in
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
