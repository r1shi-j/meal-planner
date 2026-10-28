# 🥑 GemmaBite — Zero-Waste Meal Planner & AI Nutritionist

> Built for **Hacktoberfest Hack Day Loughborough** (DigiTech x Google Gemma).  
> Competing for: **Best Use of Gemma 4** & **Open Source AI Project**.

An open-source native iOS app that tackles student food waste and meal budgeting using **Google Gemma 4's multimodal intelligence** running locally on Apple Silicon.

---

## 🌟 Key Features

1. **📸 Multimodal Food & Nutrition Scanner (Gemma 4 Vision)**
   - Snap a photo of any meal or snack directly with your iPhone camera.
   - Gemma 4 inspects the image, calculates a 1–10 Health Score, estimates Calories, Protein, Carbs, and Fats, and provides dietitian feedback.
   - 1-tap **"Add to My Recipes"** imports scanned meals straight into your recipe library.

2. **✨ AI Recipe Creator & Voice Dictation**
   - Describe a meal or speak into the phone using on-device dictation.
   - Select your target meal category (Breakfast, Lunch, Dinner).
   - Gemma 4 generates structured recipe cards (prep time, ingredients, numbered instructions) matching native Swift structs.
   - Pre-fills the recipe editor for instant review before saving.

3. **📅 Weekly Day Planner**
   - Seamless 7-day schedule (Breakfast, Lunch, Dinner).
   - Dynamic meal picker with intelligent slot suggestions and flexible cross-category assignment.
   - 1-tap **"Randomize / Auto-Fill Week"** and **"Clear All"** tools for rapid meal rotation.

4. **🛒 Automated Groceries & Pantry Sync**
   - 1-tap **"Auto-Populate"** diffs your weekly meal plan against your home pantry inventory to generate the exact missing grocery list.
   - **"Move Bought Items to Pantry"** automatically restocks your kitchen when shopping items are checked off.

---

## 🛠️ Architecture & Tech Stack

- **Client:** Native iOS (SwiftUI, iOS 17+, Swift Concurrency `async/await`, `@Observable` architecture).
- **AI Engine:** Google Gemma 4 (`gemma4:e4b-mlx`) running locally via Ollama with MLX acceleration on Apple Silicon.
- **Privacy First:** 100% of sensitive dietary, health, and grocery data stays strictly on-device with zero cloud costs.
- **Open Source:** Released under the MIT License.

---

## 🚀 Getting Started

1. **Clone the repository:**
   ```bash
   git clone https://github.com/rishijansari/meal-planner.git
   ```

2. **Run Gemma 4 locally on your Mac:**
   ```bash
   ollama run gemma4:e4b-mlx
   ```

3. **Open in Xcode:**
   Open `meal-planner.xcodeproj` in Xcode, select your iPhone or Simulator, and hit **Run (⌘R)**.

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
