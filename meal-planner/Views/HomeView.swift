//
//  HomeView.swift
//  meal-planner
//
//  Created by Rishi Jansari on 28/10/2026.
//

import SwiftUI

struct HomeView: View {
    @State private var store = MealStore()
    
    var body: some View {
        TabView {
            Tab {
                MealPlanView(store: store)
            } label: {
                Label("Plan", systemImage: "calendar")
            }
            
            Tab {
                RecipesView(store: store)
            } label: {
                Label("Recipes", systemImage: "book.closed")
            }
            
            Tab {
                PantryShoppingView(store: store)
            } label: {
                Label("Groceries", systemImage: "cart")
            }
            
            Tab {
                FoodScannerView(store: store) // Pass store so it can save recipes!
            } label: {
                Label("Scan Meal", systemImage: "camera.viewfinder")
            }
        }
    }
}

#Preview {
    HomeView()
}
