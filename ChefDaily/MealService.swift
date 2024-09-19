//
//  MealService.swift
//  ChefDaily
//
//  Created by Ruben de Koning on 16/09/2024.
//

import Foundation

class MealService {
    let baseSearchURL = "https://www.themealdb.com/api/json/v1/1/search.php?s="
    let baseFilterURL = "https://www.themealdb.com/api/json/v1/1/filter.php"
    
    func fetchMeals(searchQuery: String, filter: MealFilter, completion: @escaping (Result<[Meal], Error>) -> Void) {
        var urlString: String
        
        // Use filters if applied, otherwise use search
        if let category = filter.category, !category.isEmpty {
            urlString = baseFilterURL + "?c=" + category
        } else if let area = filter.area, !area.isEmpty {
            urlString = baseFilterURL + "?a=" + area
        } else if let ingredient = filter.ingredient, !ingredient.isEmpty {
            urlString = baseFilterURL + "?i=" + ingredient
        } else {
            // Fallback to normal search query
            urlString = baseSearchURL + searchQuery
        }
        
        guard let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No Data"])))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(MealResponse.self, from: data)
                completion(.success(decodedResponse.meals ?? []))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}

struct MealFilter {
    var category: String?
    var area: String?
    var ingredient: String?
}
