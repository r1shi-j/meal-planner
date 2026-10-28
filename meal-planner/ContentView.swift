//
//  ContentView.swift
//  meal-planner
//
//  Created by Rishi Jansari on 25/10/2026.
//

import SwiftUI

struct ContentView: View {
    @State private var number = ""
    @State private var result = ""
    @State private var isLoading = false
    @State private var error: String?
    
    var body: some View {
        VStack {
            TextField("Enter the data you wish to send", text: $number)
                .keyboardType(.numberPad)
            
            Button {
                let trimmed = number.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !trimmed.isEmpty else { return }
                
                isLoading = true
                error = nil
                result = ""
                
                Task {
                    do {
                        let respose = try await GemmaService.shared.test(info: trimmed)
                        await MainActor.run {
                            self.result = respose
                            self.isLoading = false
                        }
                    } catch {
                        await MainActor.run {
                            self.error = "Failed: \(error.localizedDescription)"
                            self.isLoading = false
                        }
                    }
                }
            } label: {
                if isLoading {
                    ProgressView()
                } else {
                    Text("Send")
                }
            }
            
            if let error {
                Text(error)
            }
            
            if !result.isEmpty {
                Text(result)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
