//
//  MealService.swift
//  ChefDaily
//
//  Created by Ruben de Koning on 16/09/2024.
//

import Foundation

class MealService {
    let baseURL = "https://www.themealdb.com/api/json/v1/1/search.php?s="
    
    func fetchMeals(searchQuery: String, completion: @escaping (Result<[Meal], Error>) -> Void) {
        
        guard let url = URL(string: baseURL + searchQuery) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) {
            data, response, error in
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
