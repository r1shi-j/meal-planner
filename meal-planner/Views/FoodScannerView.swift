//
//  FoodScannerView.swift
//  meal-planner
//
//  Created by Rishi Jansari on 28/10/2026.
//

import SwiftUI
import PhotosUI

struct FoodScannerView: View {
    @Bindable var store: MealStore
    
    @State private var selectedPhotoItem: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage? = nil
    @State private var analysis: MealAnalysis? = nil
    @State private var isAnalyzing: Bool = false
    @State private var errorMessage: String? = nil
    @State private var savedAlert: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    VStack(alignment: .leading, spacing: 4) {
                        Text("AI Nutritionist")
                            .font(.system(.largeTitle, design: .default, weight: .bold))
                            .fontWidth(.expanded)
                        
                        Text("Powered by Google Gemma 4 Vision")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top, 8)
                    
                    // Image Picker Card
                    VStack(spacing: 16) {
                        if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 220)
                                .frame(maxWidth: .infinity)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .overlay(alignment: .topTrailing) {
                                    PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                                        Image(systemName: "pencil.circle.fill")
                                            .font(.title)
                                            .foregroundStyle(.white, .black.opacity(0.6))
                                            .padding(12)
                                    }
                                }
                        } else {
                            PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                                VStack(spacing: 12) {
                                    Image(systemName: "camera.viewfinder")
                                        .font(.system(size: 44))
                                        .foregroundStyle(Color.accentColor)
                                    
                                    Text("Snap or Select Food Photo")
                                        .font(.headline)
                                        .foregroundStyle(.primary)
                                    
                                    Text("Gemma 4 will inspect calories, macros, and health score")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 180)
                                .background(Color(.secondarySystemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                            }
                        }
                        
                        if let image = selectedImage {
                            Button {
                                runAnalysis(image)
                            } label: {
                                HStack {
                                    if isAnalyzing {
                                        ProgressView().tint(.white)
                                        Text("Gemma 4 is analyzing...")
                                    } else {
                                        Image(systemName: "sparkles")
                                        Text("Analyze Nutrition with Gemma 4")
                                    }
                                }
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(isAnalyzing ? Color.gray : Color.accentColor)
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                            }
                            .disabled(isAnalyzing)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Error Banner
                    if let error = errorMessage {
                        Text(error)
                            .font(.caption)
                            .foregroundStyle(.red)
                            .padding(.horizontal)
                    }
                    
                    // MARK: - Rich Nutrition Results Card
                    if let data = analysis {
                        VStack(spacing: 16) {
                            // Dish Title & Score Badge
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(data.mealName)
                                        .font(.title3.bold())
                                    Text("Health Rating: \(data.healthScore)/10")
                                        .font(.caption.bold())
                                        .foregroundStyle(data.healthScore >= 7 ? .green : (data.healthScore >= 5 ? .orange : .red))
                                }
                                Spacer()
                                
                                // Score Badge
                                Text("\(data.healthScore)")
                                    .font(.title2.bold())
                                    .frame(width: 48, height: 48)
                                    .background(data.healthScore >= 7 ? Color.green.opacity(0.15) : Color.orange.opacity(0.15))
                                    .foregroundStyle(data.healthScore >= 7 ? Color.green : Color.orange)
                                    .clipShape(Circle())
                            }
                            
                            Divider()
                            
                            // 4-Column Macro Stats (Like Apple Fitness)
                            HStack(spacing: 8) {
                                macroBox(label: "Calories", value: "\(data.calories)", unit: "kcal", color: .orange)
                                macroBox(label: "Protein", value: data.protein, unit: "", color: .red)
                                macroBox(label: "Carbs", value: data.carbs, unit: "", color: .blue)
                                macroBox(label: "Fat", value: data.fat, unit: "", color: .yellow)
                            }
                            
                            Divider()
                            
                            // Evaluation Paragraph
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Dietitian Evaluation")
                                    .font(.caption.bold())
                                    .foregroundStyle(.secondary)
                                Text(data.evaluation)
                                    .font(.subheadline)
                                    .lineSpacing(3)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            // "Save to Recipe Book" CTA Button
                            Button {
                                let newMeal = Meal(
                                    name: data.mealName,
                                    mealSlot: .dinner,
                                    prepTime: "20 mins",
                                    ingredients: data.detectedIngredients,
                                    instructions: ["Prepared fresh based on scanned meal."]
                                )
                                store.addMeal(newMeal)
                                savedAlert = true
                            } label: {
                                HStack {
                                    Image(systemName: "plus.circle.fill")
                                    Text("Add to My Recipes")
                                }
                                .font(.subheadline.bold())
                                .frame(maxWidth: .infinity)
                                .padding(12)
                                .background(Color.accentColor.opacity(0.15))
                                .foregroundStyle(Color.accentColor)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        }
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .padding(.horizontal)
                    }
                }
                .padding(.bottom, 30)
            }
            .navigationBarTitleDisplayMode(.inline)
            .alert("Recipe Saved!", isPresented: $savedAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("This meal has been added to your Recipes tab.")
            }
            .onChange(of: selectedPhotoItem) { _, newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        await MainActor.run {
                            selectedImage = uiImage
                            analysis = nil
                            errorMessage = nil
                        }
                    }
                }
            }
        }
    }
    
    // Macro Stat Box Component
    private func macroBox(label: String, value: String, unit: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
            HStack(alignment: .lastTextBaseline, spacing: 2) {
                Text(value)
                    .font(.subheadline.bold())
                    .foregroundStyle(color)
                if !unit.isEmpty {
                    Text(unit)
                        .font(.system(size: 9))
                        .foregroundStyle(.secondary)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(Color(.tertiarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    private func runAnalysis(_ image: UIImage) {
        isAnalyzing = true
        errorMessage = nil
        analysis = nil
        
        Task {
            do {
                let result = try await GemmaService.shared.analyzeMealImageStructured(image)
                await MainActor.run {
                    self.analysis = result
                    self.isAnalyzing = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "Gemma 4 failed: \(error.localizedDescription)"
                    self.isAnalyzing = false
                }
            }
        }
    }
}

//#Preview {
//    FoodScannerView(store: <#MealStore#>)
//}
