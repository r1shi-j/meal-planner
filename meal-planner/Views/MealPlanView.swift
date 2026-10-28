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
        // MARK: - Breakfasts
        Meal(
            name: "Cheesy Scrambled Eggs",
            mealSlot: .breakfast,
            prepTime: "10 mins",
            ingredients: ["3 Large Eggs", "50g Cheddar Cheese", "1 tbsp Butter", "Chives", "Salt & Black Pepper"],
            instructions: ["Whisk eggs in a bowl with a pinch of salt", "Melt butter in non-stick pan over medium-low heat", "Pour in eggs and fold gently with a spatula", "Stir in grated cheese right before taking off heat", "Garnish with fresh chives and pepper"]
        ),
        Meal(
            name: "Overnight Berry Chia Oats",
            mealSlot: .breakfast,
            prepTime: "5 mins",
            ingredients: ["60g Rolled Oats", "150ml Almond Milk", "1 tbsp Chia Seeds", "1 scoop Vanilla Protein", "Mixed Fresh Berries", "Honey"],
            instructions: ["Combine oats, chia seeds, protein powder, and milk in a jar", "Stir well and refrigerate overnight", "Top with fresh berries and a drizzle of honey in the morning"]
        ),
        Meal(
            name: "Avocado & Sourdough Poached Eggs",
            mealSlot: .breakfast,
            prepTime: "12 mins",
            ingredients: ["2 Slices Sourdough Bread", "1 Ripe Avocado", "2 Eggs", "Chilli Flakes", "Lemon Juice", "Salt"],
            instructions: ["Toast the sourdough slices until golden", "Mash avocado with lemon juice, salt, and pepper", "Bring a pot of water to a gentle simmer with a drop of vinegar", "Swirl the water and drop in eggs to poach for 3 minutes", "Spread avocado on toast, top with poached eggs and chilli flakes"]
        ),
        Meal(
            name: "Fluffy Banana Oat Pancakes",
            mealSlot: .breakfast,
            prepTime: "15 mins",
            ingredients: ["1 Ripe Banana", "2 Eggs", "50g Blended Oats", "1/2 tsp Cinnamon", "Maple Syrup", "Butter"],
            instructions: ["Blend banana, eggs, oats, and cinnamon into a smooth batter", "Heat butter in a skillet on medium heat", "Pour small rounds of batter and cook until bubbles form (2 mins)", "Flip and cook another minute until golden", "Stack and drizzle with maple syrup"]
        ),
        Meal(
            name: "Greek Yogurt & Granola Parfait",
            mealSlot: .breakfast,
            prepTime: "5 mins",
            ingredients: ["200g Greek Yogurt", "40g Honey Granola", "Fresh Strawberries", "1 tbsp Honey", "Chia Seeds"],
            instructions: ["Spoon half of Greek yogurt into a glass or bowl", "Add a layer of sliced strawberries and half the granola", "Add remaining yogurt and top with remaining granola and chia seeds", "Finish with a generous drizzle of honey"]
        ),
        Meal(
            name: "Classic Shakshuka",
            mealSlot: .breakfast,
            prepTime: "20 mins",
            ingredients: ["3 Eggs", "1 Tin Chopped Tomatoes", "1 Red Bell Pepper", "1 Onion", "2 cloves Garlic", "Cumin & Paprika", "Crumbled Feta"],
            instructions: ["Sauté diced onion and bell pepper until soft", "Add minced garlic, cumin, and paprika and stir for 1 minute", "Pour in chopped tomatoes and simmer for 10 minutes", "Create small wells and crack eggs directly into the sauce", "Cover and cook on low for 6-8 minutes until egg whites are set", "Top with crumbled feta and serve with crusty bread"]
        ),
        // MARK: - Lunches
        Meal(
            name: "Classic Ham & Cheese Toastie",
            mealSlot: .lunch,
            prepTime: "10 mins",
            ingredients: ["2 Slices White Bread", "2 Slices Wiltshire Ham", "50g Cheddar", "1 tbsp Dijon Mustard", "Butter"],
            instructions: ["Spread butter generously on the outside of each bread slice", "Spread Dijon mustard on the inside", "Layer ham and grated cheddar inside", "Fry in a skillet on medium heat until golden and cheese is melted (3 mins per side)"]
        ),
        Meal(
            name: "Crispy Chicken Caesar Wrap",
            mealSlot: .lunch,
            prepTime: "12 mins",
            ingredients: ["1 Large Tortilla Wrap", "150g Cooked Crispy Chicken", "Romaine Lettuce", "2 tbsp Caesar Dressing", "Parmesan Shavings"],
            instructions: ["Warm the tortilla wrap in a dry pan for 20 seconds", "Toss shredded lettuce with Caesar dressing and parmesan", "Slice cooked chicken into bite-sized strips", "Lay chicken and dressed salad across the center of wrap", "Fold sides inward and roll tightly into a burrito shape"]
        ),
        Meal(
            name: "Tuna & Sweetcorn Melt",
            mealSlot: .lunch,
            prepTime: "10 mins",
            ingredients: ["1 Tin Tuna (drained)", "2 tbsp Sweetcorn", "1 tbsp Mayonnaise", "2 Slices Bread", "Cheddar Cheese"],
            instructions: ["Mix tuna, sweetcorn, and mayo in a small bowl with black pepper", "Spoon mixture generously over bread", "Top with a thick slice of cheddar cheese", "Grill under the broiler for 4-5 minutes until cheese is bubbly and golden"]
        ),
        Meal(
            name: "Caprese Pesto Ciabatta",
            mealSlot: .lunch,
            prepTime: "8 mins",
            ingredients: ["1 Ciabatta Roll", "1 Fresh Mozzarella Ball", "1 Beef Tomato", "2 tbsp Green Pesto", "Fresh Basil", "Balsamic Glaze"],
            instructions: ["Slice ciabatta roll in half and toast lightly", "Spread green basil pesto across both halves", "Layer thick slices of fresh mozzarella and tomato", "Top with fresh basil leaves and a drizzle of balsamic glaze"]
        ),
        Meal(
            name: "Spicy Peanut Sesame Noodles",
            mealSlot: .lunch,
            prepTime: "15 mins",
            ingredients: ["150g Egg Noodles", "2 tbsp Peanut Butter", "1 tbsp Soy Sauce", "1 tbsp Chilli Oil", "1 tsp Sesame Oil", "Cucumber (shredded)", "Spring Onion"],
            instructions: ["Cook noodles in boiling water for 4 minutes and drain", "Whisk peanut butter, soy sauce, chilli oil, and sesame oil with 2 tbsp warm water", "Toss warm noodles in the peanut sauce until coated", "Garnish with fresh cucumber strips and sliced spring onion"]
        ),
        Meal(
            name: "Smoked Salmon & Cream Cheese Bagel",
            mealSlot: .lunch,
            prepTime: "5 mins",
            ingredients: ["1 Sesame Bagel", "60g Smoked Salmon", "2 tbsp Cream Cheese", "Capers", "Red Onion (sliced)", "Dill"],
            instructions: ["Slice and toast the bagel until crisp", "Spread a generous layer of cream cheese on both halves", "Top with folded smoked salmon slices", "Sprinkle with capers, thinly sliced red onion, and fresh dill"]
        ),
        // MARK: - Dinners
        Meal(
            name: "Tomato & Basil Penne Pasta",
            mealSlot: .dinner,
            prepTime: "20 mins",
            ingredients: ["200g Penne Pasta", "1 Tin Italian Chopped Tomatoes", "2 cloves Garlic", "Fresh Basil", "Parmesan Cheese", "Olive Oil"],
            instructions: ["Boil salted water and cook penne for 10 minutes al dente", "Sauté thinly sliced garlic in olive oil until fragrant", "Add tomatoes, salt, and a pinch of sugar; simmer on low heat for 12 minutes", "Toss drained pasta directly into the sauce with fresh torn basil", "Serve in bowls with freshly grated parmesan"]
        ),
        Meal(
            name: "Creamy Garlic Parmesan Chicken",
            mealSlot: .dinner,
            prepTime: "25 mins",
            ingredients: ["2 Chicken Breasts", "150ml Heavy Cream", "3 cloves Garlic", "60g Baby Spinach", "50g Parmesan", "Olive Oil", "Italian Herbs"],
            instructions: ["Season chicken breasts with Italian herbs, salt, and pepper", "Sear chicken in olive oil for 6 mins per side until golden; set aside", "In same pan, fry minced garlic for 1 min", "Pour in cream and parmesan, stirring until a smooth sauce forms", "Add spinach until wilted, return chicken to pan to coat in sauce"]
        ),
        Meal(
            name: "Zero-Waste Veggie Fried Rice",
            mealSlot: .dinner,
            prepTime: "15 mins",
            ingredients: ["250g Cooked Day-Old Rice", "2 Eggs", "Frozen Mixed Peas & Sweetcorn", "1 Carrot (diced)", "2 tbsp Soy Sauce", "1 tbsp Sesame Oil"],
            instructions: ["Heat sesame oil in a wok or deep skillet over high heat", "Stir-fry diced carrots, peas, and sweetcorn for 3 minutes", "Push vegetables to side and scramble eggs directly in pan", "Add cold rice and break apart clumps with a spatula", "Drizzle with soy sauce and toss everything together on high heat for 3 minutes"]
        ),
        Meal(
            name: "Mexican Loaded Black Bean Quesadilla",
            mealSlot: .dinner,
            prepTime: "15 mins",
            ingredients: ["2 Large Flour Tortillas", "1 Tin Black Beans (rinsed)", "100g Shredded Cheese", "1/2 Red Onion", "Salsa", "Sour Cream"],
            instructions: ["Mash black beans lightly with cumin and salt", "Place one tortilla flat in a dry pan on medium heat", "Spread mashed beans, diced onion, and cheese across one half", "Fold tortilla over to form a half-moon", "Cook 3-4 mins each side until crispy and cheese melts; serve with salsa"]
        ),
        Meal(
            name: "Honey Soy Salmon with Green Beans",
            mealSlot: .dinner,
            prepTime: "20 mins",
            ingredients: ["2 Salmon Fillets", "2 tbsp Soy Sauce", "1.5 tbsp Honey", "1 clove Garlic (minced)", "150g Fresh Green Beans", "Sesame Seeds"],
            instructions: ["Whisk soy sauce, honey, and garlic together for the glaze", "Pan-sear salmon skin-side down for 4 minutes", "Flip salmon and pour glaze into pan, basting the fish for 3 minutes", "Steam green beans for 4 minutes", "Plate salmon over green beans and spoon remaining pan glaze on top"]
        ),
        Meal(
            name: "Student One-Pan Sausage & Veggie Bake",
            mealSlot: .dinner,
            prepTime: "30 mins",
            ingredients: ["6 Pork Sausages", "3 Baby Potatoes (quartered)", "1 Bell Pepper", "1 Red Onion", "2 tbsp Olive Oil", "Rosemary"],
            instructions: ["Preheat oven to 200°C (400°F)", "Toss quartered potatoes, chopped peppers, and sliced onions in olive oil and rosemary", "Spread vegetables evenly across a baking tray", "Nestle sausages between vegetables", "Bake for 25-30 minutes, turning sausages halfway, until potatoes are tender"]
        ),
        Meal(
            name: "Creamy Truffle Mac & Cheese",
            mealSlot: .dinner,
            prepTime: "20 mins",
            ingredients: ["200g Macaroni", "150g Mature Cheddar", "30g Butter", "30g Flour", "300ml Whole Milk", "Pinch of Nutmeg", "Truffle Oil"],
            instructions: ["Boil macaroni in salted water until tender; drain", "Melt butter in saucepan, whisk in flour for 1 min to make a roux", "Slowly whisk in milk until thick and creamy", "Remove from heat and stir in grated cheddar until smooth", "Fold in macaroni, season with nutmeg and black pepper, and drizzle with truffle oil"]
        ),
        Meal(
            name: "Quick Thai Red Coconut Curry",
            mealSlot: .dinner,
            prepTime: "25 mins",
            ingredients: ["1 Tin Coconut Milk", "2 tbsp Thai Red Curry Paste", "200g Tofu or Chicken", "1 Bell Pepper", "Sugar Snap Peas", "Jasmine Rice"],
            instructions: ["Fry curry paste in 2 tbsp coconut milk in a pan until aromatic (1 min)", "Add protein and cook for 4-5 minutes", "Pour in remaining coconut milk and bring to a gentle simmer", "Add sliced bell peppers and snap peas, simmering for 6 minutes", "Serve steaming hot over cooked jasmine rice"]
        )
    ]
    
    var mealPlan: MealPlan = {
        var days = Day.allCases.map { MealPlanDay(day: $0) }
        // Pre-fill Monday
        days[0].breakfast = Meal(
            name: "Avocado & Sourdough Poached Eggs",
            mealSlot: .breakfast,
            prepTime: "12 mins",
            ingredients: ["2 Slices Sourdough", "1 Avocado", "2 Eggs", "Chilli Flakes"],
            instructions: ["Toast bread", "Mash avocado with lemon", "Poach eggs for 3 mins and assemble"]
        )
        days[0].lunch = Meal(
            name: "Classic Ham & Cheese Toastie",
            mealSlot: .lunch,
            prepTime: "10 mins",
            ingredients: ["Bread", "Ham", "Cheddar", "Butter"],
            instructions: ["Butter bread on outside", "Fill with ham & cheese", "Toast until golden"]
        )
        days[0].dinner = Meal(
            name: "Tomato & Basil Penne Pasta",
            mealSlot: .dinner,
            prepTime: "20 mins",
            ingredients: ["Penne Pasta", "Chopped Tomatoes", "Garlic", "Parmesan", "Basil"],
            instructions: ["Boil penne", "Simmer garlic & tomato sauce", "Toss and top with parmesan"]
        )
        
        // Pre-fill Tuesday
        days[1].breakfast = Meal(
            name: "Overnight Berry Chia Oats",
            mealSlot: .breakfast,
            prepTime: "5 mins",
            ingredients: ["Rolled Oats", "Almond Milk", "Chia Seeds", "Berries"],
            instructions: ["Mix oats and milk", "Refrigerate overnight", "Top with berries"]
        )
        days[1].dinner = Meal(
            name: "Mexican Loaded Black Bean Quesadilla",
            mealSlot: .dinner,
            prepTime: "15 mins",
            ingredients: ["Tortillas", "Black Beans", "Cheddar", "Salsa"],
            instructions: ["Mash beans", "Fill tortilla with beans & cheese", "Toast in pan until melted"]
        )
        return MealPlan(days: days)
    }()
    
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
                        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: selectedDay)
                    }
                }
            }
            .background(Color.purple.opacity(0.2))
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
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button(role: .destructive) {
                            for index in store.mealPlan.days.indices {
                                store.mealPlan.days[index].breakfast = nil
                                store.mealPlan.days[index].lunch = nil
                                store.mealPlan.days[index].dinner = nil
                            }
                        } label: {
                            Label("Clear All Planned Meals", systemImage: "trash")
                        }
                        
                        Button {
                            for index in store.mealPlan.days.indices {
                                store.mealPlan.days[index].breakfast = store.savedMeals.filter { $0.mealSlot == .breakfast }.randomElement()
                                store.mealPlan.days[index].lunch = store.savedMeals.filter { $0.mealSlot == .lunch }.randomElement()
                                store.mealPlan.days[index].dinner = store.savedMeals.filter { $0.mealSlot == .dinner }.randomElement()
                            }
                        } label: {
                            Label("Randomize / Auto-Fill Week", systemImage: "sparkles")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
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
                    availableMeals: store.savedMeals,
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
            .sensoryFeedback(.selection, trigger: selectedDay)
        }
    }
    
    private func slotIcon(for slot: MealSlot) -> String {
        switch slot {
        case .breakfast: return "sun.horizon.fill"
        case .lunch: return "sun.max.fill"
        case .dinner: return "moon.stars.fill"
        }
    }
    
    private func slotColor(for slot: MealSlot) -> Color {
        switch slot {
        case .breakfast: return .orange
        case .lunch: return .green
        case .dinner: return .purple
        }
    }
    
    func mealSlotView(slot: MealSlot, meal: Meal?) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: slotIcon(for: slot))
                    .font(.caption2.bold())
                    .foregroundStyle(slotColor(for: slot))
                Text(slot.rawValue.uppercased())
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .foregroundStyle(.secondary)
            }
            
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
                    .clipShape(.rect(cornerRadius: 14))
                    .shadow(color: slotColor(for: slot).opacity(0.12), radius: 6, x: 0, y: 3)
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
