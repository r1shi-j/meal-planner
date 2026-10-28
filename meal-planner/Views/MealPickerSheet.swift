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
                
                Section("Saved \(slot.rawValue) Recipes") {
                    if availableMeals.isEmpty {
                        Text("No saved \(slot.rawValue.lowercased()) recipes yet.")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(availableMeals) { meal in
                            Button {
                                onSelectMeal(meal)
                                dismiss()
                            } label: {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(meal.name)
                                            .font(.headline)
                                            .foregroundStyle(.primary)
                                        Text("\(meal.prepTime) • \(meal.ingredients.count) ingredients")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                    Spacer()
                                    Image(systemName: "checkmark.circle")
                                        .foregroundStyle(Color.accentColor)
                                }
                            }
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
}
