//
//  MealPickerSheet.swift
//  meal-planner
//
//  Created by Rishi Jansari on 28/10/2026.
//

import SwiftUI

struct MealPickerSheet: View {
    @Environment(\.dismiss) private var dismiss
    let slot: MealSlot
    let availableMeals: [Meal]
    let onSelectMeal: (Meal) -> Void
    let onCreateNew: () -> Void
    
    private var matchingMeals: [Meal] {
        availableMeals.filter { $0.mealSlot == slot }
    }
    
    private var otherMeals: [Meal] {
        availableMeals.filter { $0.mealSlot != slot }
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Button {
                        dismiss()
                        onCreateNew()
                    } label: {
                        Label("Create New \(slot.rawValue)", systemImage: "plus.circle.fill")
                            .foregroundStyle(Color.accentColor)
                    }
                }
                
                // 1. Suggested matching recipes
                Section("Suggested for \(slot.rawValue)") {
                    if matchingMeals.isEmpty {
                        Text("No saved \(slot.rawValue.lowercased()) recipes yet.")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(matchingMeals) { meal in
                            mealRow(meal)
                        }
                    }
                }
                
                // 2. All other recipes in library
                if !otherMeals.isEmpty {
                    Section("Other Recipes") {
                        ForEach(otherMeals) { meal in
                            mealRow(meal)
                        }
                    }
                }
            }
            .navigationTitle("Choose \(slot.rawValue)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
    
    @ViewBuilder
    private func mealRow(_ meal: Meal) -> some View {
        Button {
            onSelectMeal(meal)
            dismiss()
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(meal.name)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    HStack(spacing: 8) {
                        Text(meal.mealSlot.rawValue)
                            .font(.caption2.bold())
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.accentColor.opacity(0.15))
                            .foregroundStyle(Color.accentColor)
                            .clipShape(Capsule())
                        
                        Text("\(meal.prepTime) • \(meal.ingredients.count) ingredients")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                Spacer()
                Image(systemName: "checkmark.circle")
                    .foregroundStyle(Color.accentColor)
            }
        }
    }
}
