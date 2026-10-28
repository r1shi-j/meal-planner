//
//  MealDetailView.swift
//  meal-planner
//
//  Created by Rishi Jansari on 28/10/2026.
//

import SwiftUI

struct MealDetailView: View {
    @Environment(\.dismiss) private var dismiss
    let meal: Meal
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .center, spacing: 20) {
                    // header card
                    VStack(alignment: .leading, spacing: 8) {
                        Text(meal.name)
                            .font(.title2.bold())
                        
                        HStack(spacing: 12) {
                            Label(meal.prepTime, systemImage: "clock")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            
                            Label("\(meal.ingredients.count) ingredients", systemImage: "takeoutbag.and.cup.and.straw")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .clipShape(.rect(cornerRadius: 16))
                    
                    // ingredients card
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Ingredients")
                            .font(.headline)
                        
                        if meal.ingredients.isEmpty {
                            Text("No ingredients listed.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        } else {
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(meal.ingredients, id: \.self) { ingredient in
                                    HStack(spacing: 8) {
                                        Image(systemName: "circle.fill")
                                            .font(.system(size: 6))
                                            .foregroundStyle(.tint)
                                        Text(ingredient)
                                            .font(.body)
                                    }
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .clipShape(.rect(cornerRadius: 16))
                    
                    // instructions card
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Instructions")
                            .font(.headline)
                        
                        if meal.instructions.isEmpty {
                            Text("No instructions listed.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        } else {
                            VStack(alignment: .leading, spacing: 12) {
                                ForEach(Array(meal.instructions.enumerated()), id: \.offset) { index, step in
                                    HStack(alignment: .top, spacing: 12) {
                                        Text("\(index + 1)")
                                            .font(.caption.bold())
                                            .frame(width: 24, height: 24)
                                            .background(Color.accentColor.opacity(0.15))
                                            .foregroundStyle(Color.accentColor)
                                            .clipShape(.circle)
                                        
                                        Text(step)
                                            .font(.body)
                                    }
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .clipShape(.rect(cornerRadius: 16))
                    
                    // delete button
                    Button(role: .destructive) {
                        onDelete()
                        dismiss()
                    } label: {
                        Label("Remove from Meal Plan", systemImage: "trash")
                            .padding(4)
                            .font(.system(.headline, design: .default, weight: .semibold))
                            .fontWidth(.expanded)
                    }
                    .frame(alignment: .center)
                    .padding()
                    .tint(.red)
                    .buttonStyle(.glassProminent)
                }
                .padding()
            }
            .navigationTitle("Recipe")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button("Edit") {
                        dismiss()
                        onEdit()
                    }
                }
            }
        }
    }
}

#Preview {
    MealDetailView(meal: Meal(name: "Test Meal", mealSlot: .breakfast, ingredients: ["Ing", "a", "b", "c", "a", "b", "c"], instructions: ["a", "b", "c", "a", "b", "c"]), onEdit: {}, onDelete: {})
}
