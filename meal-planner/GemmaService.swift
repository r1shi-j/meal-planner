//
//  GemmaService.swift
//  meal-planner
//
//  Created by Rishi Jansari on 27/10/2026.
//

import Foundation
import UIKit

//let address = "10.107.25.4"
//let address = "localhost"
let address = "Rishis-MacBook-Pro.local"


class GemmaService {
    static let shared = GemmaService()
    
    private let endpoint = URL(string: "http://\(address):11434/api/generate")!
    
    func test(info: String) async throws -> String {
        let prompt = """
    You are an expert mathematician. 
    Calculate the following for the number \(info):
    - (\(info)!)
    - !!(\(info))
    - natural log (ln \(info))
    Respond ONLY with a valid JSON object matching this exact format:
    {
      "input": \(info),
      "factorial": "<result>",
      "double_sub_factorial": "<result>",
      "natural_log": "<result>",
      "explanation": "<short 1-sentence math explanation>"
    }
    """
        
        let body: [String: Any] = [
            "model": "gemma4:e4b-mlx",
            "prompt": prompt,
            "stream": false,
            "format": "json"
        ]
        
        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        struct OllamaWrapper: Codable {
            let response: String
        }
        
        let wrapper = try JSONDecoder().decode(OllamaWrapper.self, from: data)
        print(wrapper, wrapper.response)
        return wrapper.response
    }
    
    // Inside class GemmaService:
    func analyzeMealImage(_ image: UIImage) async throws -> String {
        // 1. Compress image to lightweight JPEG (keeps upload under ~300KB)
        guard let imageData = image.jpegData(compressionQuality: 0.6) else {
            throw URLError(.cannotDecodeContentData)
        }
        let base64Image = imageData.base64EncodedString()
        
        let prompt = """
    You are an expert nutritionist. Analyze this food image:
    1. Identify what food or meal this is.
    2. Give it a Health Rating from 1 to 10 with a short reason.
    3. Estimate approximate calories and key macros (protein, carbs, healthy fats).
    4. Write a concise, engaging paragraph evaluating how balanced this meal is, and suggest any healthy additions or tweaks.
    """
        
        let body: [String: Any] = [
            "model": "gemma4:e4b-mlx",
            "prompt": prompt,
            "images": [base64Image], // <-- Ollama accepts base64 images here!
            "stream": false
        ]
        
        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        struct OllamaWrapper: Codable {
            let response: String
        }
        
        let wrapper = try JSONDecoder().decode(OllamaWrapper.self, from: data)
        return wrapper.response
    }
    
    func generateRecipe(from description: String, slot: MealSlot) async throws -> Meal {
        let prompt = """
    You are an expert chef. Create a complete recipe based on this description: "\(description)".
    The meal category is \(slot.rawValue).
    
    Respond ONLY with a valid JSON object matching this exact format:
    {
      "name": "Recipe Title",
      "mealSlot": "\(slot.rawValue)",
      "prepTime": "e.g. 20 mins",
      "ingredients": ["item 1", "item 2", "item 3"],
      "instructions": ["Step 1...", "Step 2..."],
      "missingItems": []
    }
    """
        
        let body: [String: Any] = [
            "model": "gemma4:e4b-mlx",
            "prompt": prompt,
            "stream": false,
            "format": "json"
        ]
        
        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        struct OllamaWrapper: Codable {
            let response: String
        }
        
        let wrapper = try JSONDecoder().decode(OllamaWrapper.self, from: data)
        guard let responseData = wrapper.response.data(using: .utf8) else {
            throw URLError(.cannotParseResponse)
        }
        
        return try JSONDecoder().decode(Meal.self, from: responseData)
    }
    
    func analyzeMealImageStructured(_ image: UIImage) async throws -> MealAnalysis {
        guard let imageData = image.jpegData(compressionQuality: 0.6) else {
            throw URLError(.cannotDecodeContentData)
        }
        let base64Image = imageData.base64EncodedString()
        
        let prompt = """
    You are an expert nutritionist. Analyze this food image.
    Respond ONLY with a valid JSON object matching this exact schema:
    {
      "mealName": "Name of dish",
      "healthScore": 8,
      "calories": 450,
      "protein": "25g",
      "carbs": "35g",
      "fat": "12g",
      "evaluation": "One concise paragraph on nutritional balance and a healthy tweak.",
      "detectedIngredients": ["item 1", "item 2"]
    }
    """
        
        let body: [String: Any] = [
            "model": "gemma4:e4b-mlx",
            "prompt": prompt,
            "images": [base64Image],
            "stream": false,
            "format": "json"
        ]
        
        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        struct OllamaWrapper: Codable {
            let response: String
        }
        
        let wrapper = try JSONDecoder().decode(OllamaWrapper.self, from: data)
        
        // Clean any markdown formatting or extra text:
        var rawText = wrapper.response.trimmingCharacters(in: .whitespacesAndNewlines)
        if let firstBrace = rawText.firstIndex(of: "{"),
           let lastBrace = rawText.lastIndex(of: "}") {
            rawText = String(rawText[firstBrace...lastBrace])
        }
        
        guard let responseData = rawText.data(using: .utf8) else {
            throw URLError(.cannotParseResponse)
        }
        
        return try JSONDecoder().decode(MealAnalysis.self, from: responseData)
    }

}

struct MealAnalysis: Codable {
    var mealName: String
    var healthScore: Int
    var calories: Int
    var protein: String
    var carbs: String
    var fat: String
    var evaluation: String
    var detectedIngredients: [String]
    
    enum CodingKeys: String, CodingKey {
        case mealName, healthScore, calories, protein, carbs, fat, evaluation, detectedIngredients
    }
    
    // Bulletproof custom decoder: Never crashes if Gemma sends strings instead of numbers!
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.mealName = try container.decodeIfPresent(String.self, forKey: .mealName) ?? "Scanned Dish"
        
        // Handle healthScore as Int (8), Double (8.5), or String ("8/10")
        if let intVal = try? container.decode(Int.self, forKey: .healthScore) {
            self.healthScore = intVal
        } else if let dblVal = try? container.decode(Double.self, forKey: .healthScore) {
            self.healthScore = Int(dblVal)
        } else if let strVal = try? container.decode(String.self, forKey: .healthScore),
                  let parsed = Int(strVal.filter(\.isNumber)) {
            self.healthScore = parsed
        } else {
            self.healthScore = 7
        }
        
        // Handle calories as Int (450) or String ("450 kcal")
        if let intVal = try? container.decode(Int.self, forKey: .calories) {
            self.calories = intVal
        } else if let strVal = try? container.decode(String.self, forKey: .calories),
                  let parsed = Int(strVal.filter(\.isNumber)) {
            self.calories = parsed
        } else {
            self.calories = 400
        }
        
        self.protein = try container.decodeIfPresent(String.self, forKey: .protein) ?? "20g"
        self.carbs = try container.decodeIfPresent(String.self, forKey: .carbs) ?? "35g"
        self.fat = try container.decodeIfPresent(String.self, forKey: .fat) ?? "12g"
        self.evaluation = try container.decodeIfPresent(String.self, forKey: .evaluation) ?? "Nutritious and well-balanced meal."
        self.detectedIngredients = try container.decodeIfPresent([String].self, forKey: .detectedIngredients) ?? []
    }
}

//curl http://localhost:11434/api/generate -d '{
//"model": "gemma4:e4b-mlx",
//"prompt": "Suggest a quick 2-ingredient dinner in JSON format with keys name, time, ingredients.",
//"stream": false,
//"format": "json"
//}'
//
//curl "https://generativelanguage.googleapis.com/v1beta/models/gemini-flash-latest:generateContent" \
//-H 'Content-Type: application/json' \
//-X POST \
//-d '{
//    "contents": [
//        {
//            "parts": [
//                {
//                    "text": "Explain how AI works in a few words"
//                }
//            ]
//        }
//    ]
//}'
