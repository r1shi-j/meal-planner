//
//  RecipesView.swift
//  meal-planner
//
//  Created by Rishi Jansari on 28/10/2026.
//

import SwiftUI

struct RecipesView: View {
    @Bindable var store: MealStore
    @State private var selectedFilter: MealSlot? = nil
    @State private var isCreatingMeal: Bool = false
    @State private var editingMeal: Meal? = nil
    @State private var selectedMeal: Meal? = nil
    
    @State private var showingAIGenerator: Bool = false
    @State private var aiDescription: String = ""
    @State private var isGeneratingRecipe: Bool = false
    @State private var prefilledMeal: Meal? = nil // <-- Holds the AI-generated meal to review
    @State private var aiErrorMessage: String? = nil
    
    private var filteredMeals: [Meal] {
        if let filter = selectedFilter {
            return store.savedMeals.filter { $0.mealSlot == filter }
        }
        return store.savedMeals
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // category filters
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        filterChip(title: "All", isSelected: selectedFilter == nil) {
                            selectedFilter = nil
                        }
                        ForEach(MealSlot.allCases) { slot in
                            filterChip(title: slot.rawValue, isSelected: selectedFilter == slot) {
                                selectedFilter = slot
                            }
                        }
                    }
                    .padding()
                }
                
                // list of meals for that category
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(filteredMeals) { meal in
                            Button {
                                selectedMeal = meal
                            } label: {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(meal.name)
                                            .font(.headline)
                                            .foregroundStyle(.primary)
                                        Text("\(meal.mealSlot.rawValue) • \(meal.prepTime)")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(.secondary)
                                }
                                .padding()
                                .background(Color(.secondarySystemBackground))
                                .clipShape(.rect(cornerRadius: 16))
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .title) {
                    Text("Recipes")
                        .font(.system(.title, design: .default, weight: .bold))
                        .fontWidth(.expanded)
                }
                
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        isCreatingMeal = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                
                ToolbarItemGroup(placement: .primaryAction) {
                    // AI Generator Button
                    Button {
                        showingAIGenerator = true
                    } label: {
                        Image(systemName: "sparkles")
                            .foregroundStyle(Color.accentColor)
                    }
                }
            }
            
            .sheet(item: $selectedMeal) { meal in
                MealDetailView(meal: meal) {
                    selectedMeal = nil
                    editingMeal = meal
                } onDelete: {
                    store.deleteMeal(meal)
                }
            }
            .sheet(isPresented: $isCreatingMeal) {
                MealEditorView(meal: Meal(name: "", mealSlot: selectedFilter ?? .dinner)) { newMeal in
                    store.addMeal(newMeal)
                }
            }
            .sheet(item: $editingMeal) { mealToEdit in
                MealEditorView(meal: mealToEdit) { updatedMeal in
                    if let index = store.savedMeals.firstIndex(where: { $0.id == updatedMeal.id }) {
                        store.savedMeals[index] = updatedMeal
                    }
                }
            }
            .sheet(item: $prefilledMeal) { generatedMeal in
                MealEditorView(meal: generatedMeal) { finalMeal in
                    // User reviewed, edited if needed, and tapped Save!
                    store.addMeal(finalMeal)
                    prefilledMeal = nil
                }
            }
            .sheet(isPresented: $showingAIGenerator) {
                NavigationStack {
                    VStack(spacing: 20) {
                        Text("Describe what you want to make, or tap the keyboard microphone to dictate:")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                            .padding(.top)
                        
                        TextEditor(text: $aiDescription)
                            .frame(height: 120)
                            .padding(8)
                            .background(Color(.secondarySystemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .padding(.horizontal)
                            .overlay(alignment: .topLeading) {
                                if aiDescription.isEmpty {
                                    Text("e.g. Creamy garlic pasta with mushrooms and parmesan in under 20 mins...")
                                        .foregroundStyle(.tertiary)
                                        .padding(.horizontal, 24)
                                        .padding(.top, 16)
                                        .allowsHitTesting(false)
                                }
                            }
                        
                        if let error = aiErrorMessage {
                            Text(error)
                                .font(.caption)
                                .foregroundStyle(.red)
                                .padding(.horizontal)
                        }
                        
                        Button {
                            generateAIMeal()
                        } label: {
                            HStack {
                                if isGeneratingRecipe {
                                    ProgressView()
                                        .tint(.white)
                                    Text("Gemma 4 is drafting recipe...")
                                } else {
                                    Image(systemName: "wand.and.stars")
                                    Text("Generate Recipe")
                                }
                            }
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(aiDescription.trimmingCharacters(in: .whitespaces).isEmpty || isGeneratingRecipe ? Color.gray : Color.accentColor)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .disabled(aiDescription.trimmingCharacters(in: .whitespaces).isEmpty || isGeneratingRecipe)
                        .padding(.horizontal)
                        
                        Spacer()
                    }
                    .navigationTitle("AI Recipe Creator")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") { showingAIGenerator = false }
                        }
                    }
                }
                .presentationDetents([.medium])
            }
        }
    }
    
    func filterChip(title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .fontWeight(isSelected ? .bold : .regular)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.accentColor : Color(.secondarySystemBackground))
                .foregroundStyle(isSelected ? .white : .primary)
                .clipShape(.capsule)
        }
    }
    
    private func generateAIMeal() {
        let desc = aiDescription.trimmingCharacters(in: .whitespaces)
        guard !desc.isEmpty else { return }
        
        isGeneratingRecipe = true
        aiErrorMessage = nil
        
        Task {
            do {
                let slot = selectedFilter ?? .dinner
                let generatedMeal = try await GemmaService.shared.generateRecipe(from: desc, slot: slot)
                await MainActor.run {
                    self.isGeneratingRecipe = false
                    self.showingAIGenerator = false
                    self.aiDescription = ""
                    // Opens the prefilled MealEditorView so the user can review before saving!
                    self.prefilledMeal = generatedMeal
                }
            } catch {
                await MainActor.run {
                    self.aiErrorMessage = "Gemma 4 failed: \(error.localizedDescription)"
                    self.isGeneratingRecipe = false
                }
            }
        }
    }
}
