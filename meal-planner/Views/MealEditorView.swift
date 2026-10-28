//
//  MealEditorView.swift
//  meal-planner
//
//  Created by Rishi Jansari on 28/10/2026.
//

import SwiftUI

struct MealEditorView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State var meal: Meal
    let onSave: (Meal) -> Void
    
    @State private var newIngredient: String = ""
    @State private var newInstruction: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Meal Details") {
                    TextField("Recipe Name (e.g. Scrambled Eggs)", text: $meal.name)
                    TextField("Prep Time (e.g. 15 mins)", text: $meal.prepTime)
                }
                
                Section("Ingredients") {
                    ForEach(meal.ingredients, id: \.self) { item in
                        Text(item)
                    }
                    .onDelete { indices in
                        meal.ingredients.remove(atOffsets: indices)
                    }
                    
                    HStack {
                        TextField("Add ingredient...", text: $newIngredient)
                        Button {
                            let trimmed = newIngredient.trimmingCharacters(in: .whitespaces)
                            if !trimmed.isEmpty {
                                meal.ingredients.append(trimmed)
                                newIngredient = ""
                            }
                        } label: {
                            Image(systemName: "plus.circle.fill")
                        }
                        .disabled(newIngredient.trimmingCharacters(in: .whitespaces).isEmpty)
                    }
                }
                
                Section("Instructions") {
                    ForEach(Array(meal.instructions.enumerated()), id: \.offset) { index, step in
                        Text("\(index + 1). \(step)")
                    }
                    .onDelete { indices in
                        meal.instructions.remove(atOffsets: indices)
                    }
                    
                    HStack {
                        TextField("Add step...", text: $newInstruction)
                        Button {
                            let trimmed = newInstruction.trimmingCharacters(in: .whitespaces)
                            if !trimmed.isEmpty {
                                meal.instructions.append(trimmed)
                                newInstruction = ""
                            }
                        } label: {
                            Image(systemName: "plus.circle.fill")
                        }
                        .disabled(newInstruction.trimmingCharacters(in: .whitespaces).isEmpty)
                    }
                }
            }
            .navigationTitle(meal.name.isEmpty ? "New Meal" : "Edit Meal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onSave(meal)
                        dismiss()
                    }
                    .disabled(meal.name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}

#Preview {
    MealEditorView(meal: Meal(name: "Test Meal", mealSlot: .breakfast, ingredients: ["Ing", "a", "b", "c", "a", "b", "c"], instructions: ["a", "b", "c", "a", "b", "c"]), onSave: { _ in })
}
