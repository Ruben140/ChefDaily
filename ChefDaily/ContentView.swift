//
//  ContentView.swift
//  ChefDaily
//
//  Created by Ruben de Koning on 16/09/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = MealViewModel()
    
    let categories = ["Seafood", "Beef", "Chicken"]
    let areas = ["Italian", "Chinese", "Mexican"]
    let ingredients = ["Chicken", "Rice", "Potato"]
    
    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                TextField("Search for meals...", text: $viewModel.searchQuery)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                // Filter Options
                VStack {
                    // Category Picker
                    Picker("Select Category", selection: $viewModel.selectedCategory) {
                        ForEach(categories, id: \.self) { category in
                            Text(category).tag(category) // Ensure tag matches the viewModel default
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    
                    // Area Picker
                    Picker("Select Area", selection: $viewModel.selectedArea) {
                        ForEach(areas, id: \.self) { area in
                            Text(area).tag(area) // Ensure tag matches the viewModel default
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    
                    // Ingredient Picker
                    Picker("Select Ingredient", selection: $viewModel.selectedIngredient) {
                        ForEach(ingredients, id: \.self) { ingredient in
                            Text(ingredient).tag(ingredient) // Ensure tag matches the viewModel default
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                
                // Meal List
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
                AsyncImage(url: url) { image in
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
