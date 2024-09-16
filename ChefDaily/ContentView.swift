//
//  ContentView.swift
//  ChefDaily
//
//  Created by Ruben de Koning on 16/09/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = MealViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Search for meals...", text: $viewModel.searchQuery)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                if viewModel.meals.isEmpty {
                    Text("No results found")
                        .padding()
                } else {
                    List(viewModel.meals) { meal in
                        NavigationLink(destination: MealDetailView(meal: meal)) {
                            MealRow(meal: meal)
                        }
                    }
                }
            }
            .navigationTitle("Recipe Search")
        }
    }
}

struct MealRow: View {
    let meal: Meal
    
    var body: some View {
        HStack {
            if let urlString = meal.strMealThumb, let url = URL(string: urlString) {
                AsyncImage(url: url) {image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                        .cornerRadius(8)
                } placeholder: {
                    ProgressView()
                }
            }
            Text(meal.strMeal)
                .font(.headline)
                .padding(.leading, 10)
        }
        .padding(.vertical, 5)
    }
}

#Preview {
    ContentView()
}
