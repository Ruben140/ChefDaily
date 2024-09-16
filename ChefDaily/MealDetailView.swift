//
//  MealDetailView.swift
//  ChefDaily
//
//  Created by Ruben de Koning on 16/09/2024.
//

import SwiftUI

struct MealDetailView: View {
    let meal: Meal
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10){
                if let urlString = meal.strMealThumb, let url = URL(string: urlString) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity)
                    } placeholder: {
                        ProgressView()
                    }
                }
                
                Text(meal.strMeal)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)
                
                if let category = meal.strCategory {
                    Text("Category: \(category)")
                        .font(.headline)
                }
                
                if let instructions = meal.strInstructions {
                    Text("Instructions")
                        .font(.title2)
                        .padding(.top)
                    
                    Text(instructions)
                        .font(.body)
                        .padding(.top, 5)
                }
            }
            .padding()
        }
        .navigationTitle(meal.strMeal)
    }
}
