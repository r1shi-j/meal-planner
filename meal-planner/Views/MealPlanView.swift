//
//  MealPlanView.swift
//  meal-planner
//
//  Created by Rishi Jansari on 28/10/2026.
//

import SwiftUI

enum Day: String, Codable, CaseIterable, Identifiable {
    case Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday
    
    var id: String { rawValue }
}

enum MealSlot: String, Codable, CaseIterable, Identifiable {
    case breakfast = "Breakfast"
    case lunch = "Lunch"
    case dinner = "Dinner"
    
    var id: String { rawValue }
}

struct Meal: Codable, Identifiable {
    var id: UUID = UUID()
    var name: String
    var mealSlot: MealSlot
    var prepTime: String = "15 mins"
    var ingredients: [String] = []
    var instructions: [String] = []
    var missingItems: [String] = []
    
    enum CodingKeys: String, CodingKey {
        case name, mealSlot, prepTime, ingredients, instructions, missingItems
    }
}

struct MealPlanDay: Codable, Identifiable {
    var id: String { day.rawValue }
    let day: Day
    var breakfast: Meal? = nil
    var lunch: Meal? = nil
    var dinner: Meal? = nil
}

extension MealPlanDay {
    // Read meal by slot
    func meal(for slot: MealSlot) -> Meal? {
        switch slot {
            case .breakfast: return breakfast
            case .lunch: return lunch
            case .dinner: return dinner
        }
    }
    
    // Set meal by slot
    mutating func setMeal(_ meal: Meal?, for slot: MealSlot) {
        switch slot {
            case .breakfast: breakfast = meal
            case .lunch: lunch = meal
            case .dinner: dinner = meal
        }
    }
}

struct MealPlan: Codable {
    var days: [MealPlanDay]
}

@Observable
class MealStore {
    var savedMeals: [Meal] = [
        Meal(
            name: "Cheesy Scrambled Eggs",
            mealSlot: .breakfast,
            prepTime: "10 mins",
            ingredients: ["3 Eggs", "Cheddar Cheese", "Butter", "Salt & Pepper"],
            instructions: ["Melt butter in pan", "Whisk eggs with cheese", "Scramble on low heat until soft"]
        ),
        Meal(
            name: "Tomato & Basil Pasta",
            mealSlot: .dinner,
            prepTime: "20 mins",
            ingredients: ["Penne Pasta", "Tomato Sauce", "Garlic", "Parmesan"],
            instructions: ["Boil pasta for 10 mins", "Simmer tomato sauce with garlic", "Mix and top with cheese"]
        ),
        Meal(
            name: "Classic Ham & Cheese Toastie",
            mealSlot: .lunch,
            prepTime: "10 mins",
            ingredients: ["2 Slices Bread", "Ham", "Cheese Slice", "Butter"],
            instructions: ["Butter the outside of bread", "Layer ham and cheese inside", "Toast in frying pan until golden"]
        )
    ]
    
    var mealPlan = MealPlan(days: Day.allCases.map { MealPlanDay(day: $0) })
    
    func addMeal(_ meal: Meal) {
        savedMeals.append(meal)
    }
    
    func deleteMeal(_ meal: Meal) {
        savedMeals.removeAll { $0.id == meal.id }
    }
    
    // Inside class MealStore, add these properties & starter data:
    var shoppingList: [ShoppingItem] = [
        ShoppingItem(name: "Greek Yogurt", category: "Dairy"),
        ShoppingItem(name: "Eggs (6 pack)", category: "Dairy"),
        ShoppingItem(name: "Garlic", category: "Produce"),
        ShoppingItem(name: "Parmesan", category: "Dairy")
    ]
    
    var pantry: [PantryItem] = [
        PantryItem(name: "Penne Pasta", quantity: 2, category: "Dry Goods"),
        PantryItem(name: "Tomato Sauce", quantity: 1, category: "Canned"),
        PantryItem(name: "Olive Oil", quantity: 1, category: "Oils"),
        PantryItem(name: "Cheddar Cheese", quantity: 1, category: "Dairy")
    ]
    
    // Helper to pull all ingredients from the week's meal plan into the shopping list
    func generateShoppingListFromWeekPlan() {
        var allIngredients: Set<String> = []
        for day in mealPlan.days {
            if let b = day.breakfast { allIngredients.formUnion(b.ingredients) }
            if let l = day.lunch { allIngredients.formUnion(l.ingredients) }
            if let d = day.dinner { allIngredients.formUnion(d.ingredients) }
        }
        
        // Add ingredients not already in shopping list or pantry
        for ingredient in allIngredients {
            let trimmed = ingredient.trimmingCharacters(in: .whitespaces)
            if !shoppingList.contains(where: { $0.name.localizedCaseInsensitiveContains(trimmed) }) &&
                !pantry.contains(where: { $0.name.localizedCaseInsensitiveContains(trimmed) }) {
                shoppingList.append(ShoppingItem(name: trimmed))
            }
        }
    }
}

struct ActiveMealContext: Identifiable {
    var id: String { "\(day.rawValue)-\(slot.rawValue)" }
    let day: Day
    let slot: MealSlot
    var meal: Meal
}

struct ShoppingItem: Identifiable, Codable {
    var id: UUID = UUID()
    var name: String
    var isChecked: Bool = false
    var category: String = "Groceries"
}

struct PantryItem: Identifiable, Codable {
    var id: UUID = UUID()
    var name: String
    var quantity: Int = 1
    var category: String = "Pantry"
}


struct MealPlanView: View {
    @Bindable var store: MealStore
    
    @State private var selectedMeal: Meal? = nil
    @State private var selectedDay: Day = .Monday
    
    @State private var viewingMeal: Meal? = nil
    @State private var activeContext: ActiveMealContext? = nil
    
    @State private var pickingSlot: MealSlot? = nil
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(Day.allCases) { day in
                            Button {
                                withAnimation {
                                    selectedDay = day
                                }
                            } label: {
                                Text(day.rawValue.prefix(3))
                                    .fontWeight(selectedDay == day ? .bold : .regular)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(selectedDay == day ? Color.accentColor : Color(.secondarySystemBackground))
                                    .foregroundStyle(selectedDay == day ? .white : .primary)
                                    .clipShape(.capsule)
                            }
                        }
                    }
                    .padding()
                }
                
                if let currentDayPlan = store.mealPlan.days.first(where: { $0.day == selectedDay }) {
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(MealSlot.allCases) { slot in
                                mealSlotView(slot: slot, meal: currentDayPlan.meal(for: slot))
                            }
                        }
                        .padding()
                    }
                }
            }
//            .refreshable {
//                print("Resetting all")
//            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .title) {
                    Text("Weekly Meal Plan")
                        .font(.system(.title, design: .default, weight: .bold))
                        .fontWidth(.expanded)
                }
//                ToolbarItem(placement: .topBarTrailing) {
//                    Button("Clear") {
//
//                    }
//                }
            }
            .sheet(item: $viewingMeal) { meal in
                MealDetailView(meal: meal) {
                    activeContext = ActiveMealContext(day: selectedDay, slot: meal.mealSlot, meal: meal)
                } onDelete: {
                    deleteMeal(for: selectedDay, slot: meal.mealSlot)
                }
            }
            .sheet(item: $activeContext) { context in
                MealEditorView(meal: context.meal) { updatedMeal in
                    // Save to this day's plan
                    saveMeal(updatedMeal, for: context.day, slot: context.slot)
                    
                    // Also add to saved recipe library if it's new
                    if !store.savedMeals.contains(where: { $0.id == updatedMeal.id }) {
                        store.addMeal(updatedMeal)
                    }
                }
            }
            .sheet(item: $pickingSlot) { slot in
                MealPickerSheet(
                    slot: slot,
                    availableMeals: store.savedMeals.filter { $0.mealSlot == slot },
                    onSelectMeal: { chosenMeal in
                        saveMeal(chosenMeal, for: selectedDay, slot: slot)
                    },
                    onCreateNew: {
                        activeContext = ActiveMealContext(
                            day: selectedDay,
                            slot: slot,
                            meal: Meal(name: "", mealSlot: slot)
                        )
                    }
                )
            }
        }
    }
    
    func mealSlotView(slot: MealSlot, meal: Meal?) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(slot.rawValue)
                .font(.caption.bold())
                .foregroundStyle(.secondary)
            
            if let meal, !meal.name.isEmpty {
                Button {
                    viewingMeal = meal
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
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .clipShape(.rect(cornerRadius: 12))
                }
            } else {
                // no meal selected
                Button {
                    pickingSlot = slot
                } label: {
                    HStack {
                        Image(systemName: "plus.circle.dashed")
                        Text("Add \(slot.rawValue)")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemBackground))
                    .clipShape(.rect(cornerRadius: 12))
                    .foregroundStyle(.secondary)
                }
            }
        }
    }
    
    private func saveMeal(_ meal: Meal, for day: Day, slot: MealSlot) {
        if let index = store.mealPlan.days.firstIndex(where: { $0.day == day }) {
            store.mealPlan.days[index].setMeal(meal, for: slot)
        }
    }
    
    private func deleteMeal(for day: Day, slot: MealSlot) {
        if let index = store.mealPlan.days.firstIndex(where: { $0.day == day }) {
            store.mealPlan.days[index].setMeal(nil, for: slot)
        }
    }
}

#Preview {
    MealPlanView(store: MealStore())
}
