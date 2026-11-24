//
//  WeatherCheck.swift
//  FoundationCheck
//
//  Created by karthik kumar Choppavarapu on 21/11/26.
//

import SwiftUI
import FoundationModels


struct PromptMessage: Identifiable, Equatable {
    let id = UUID()
    var text: String
    let isUser: Bool
    let timestamp = Date()
}


struct PromptView<T: Generable>: View {
    
    var instructions: String;
    var navTitle: String;
    @State private var messages: [PromptMessage] = [
        PromptMessage(text: "Hi User! How can I help you today?", isUser: false)]
    @State private var inputText: String = ""
    @State private var isTyping: Bool = false
    @FocusState private var isInputFocused: Bool
//    @State private var partialRecipe: RecipeModel.PartiallyGenerated?
//    @State private var partialWeather: WeatherModel.PartiallyGenerated?
//    @State private var partialContent: T.PartiallyGenerated?

    var body: some View {
            NavigationStack {
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(messages) { message in
                                MessageBubble(message: message)
                                    .id(message.id)
                            }

                            if isTyping {
                                TypingIndicatorBubble()
                                    .id("typing_indicator")
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 12)
                        .padding(.bottom, 8)
                    }
                    .scrollDismissesKeyboard(.interactively)
                    .onTapGesture {
                        isInputFocused = false
                    }
                    .onChange(of: messages) {
                        scrollToBottom(proxy: proxy)
                    }
                    .onChange(of: isTyping) {
                        scrollToBottom(proxy: proxy)
                    }
                }
                .navigationTitle(navTitle)
                .navigationBarTitleDisplayMode(.inline)
                .safeAreaInset(edge: .bottom) {
                    inputBar
                }
            }
        }
    
    private var canSend: Bool {
         !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !isTyping
     }

     private func sendMessage() {
         let trimmed = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
         guard !trimmed.isEmpty else { return }

         let userMessage = PromptMessage(text: trimmed, isUser: true)
         messages.append(userMessage)
         inputText = ""

         Task {
             do {
                 try await generateResponse(to: trimmed)
             } catch {
                 print("Request failed: \(error)")
             }
         }
     }
    
    private var inputBar: some View {
        HStack(alignment: .bottom, spacing: 10) {
            TextField("Message...", text: $inputText, axis: .vertical)
                .lineLimit(1...5)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(Color(.lightGray))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .focused($isInputFocused)

            Button(action: sendMessage) {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 32))
                    .foregroundStyle(canSend ? Color.blue : Color.gray.opacity(0.4))
            }
            .disabled(!canSend)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(.bar)
    }
    
    private func generateResponse(to prompt: String) async throws {
        isTyping = true

        // Simulate network or AI model latency
        try? await Task.sleep(for: .seconds(1.2))
        
/*        let instructionsSession = LanguageModelSession()
        let result = try? await instructionsSession.respond(
            to: Prompt(prompt),
        )
        isTyping = false
        messages.append(PromptMessage(text: result!.content, isUser: false))
        */
        
      
        let instructionsSession = LanguageModelSession(instructions: instructions)
        let stream = instructionsSession.streamResponse(
            to: prompt,
            generating: T.self,
            includeSchemaInPrompt: false, options: GenerationOptions()
        )
        isTyping = false
        messages.append(PromptMessage(text: "", isUser: false))
        let messageIndex = messages.count - 1
       
        for try await partial in stream {
            //               self.partialContent = partial.content
            
            if let recipe = partial.content as? RecipeModel.PartiallyGenerated {
                let title = recipe.title ?? ""
                let ingredients = recipe.ingredients?.joined(separator: ", ") ?? ""
                let procedure = recipe.procedure?.joined(separator: ", ") ?? ""
                messages[messageIndex].text = "\(title)\n\(ingredients)\n\(procedure)"
            }
            else if let weather = partial.content as? WeatherModel.PartiallyGenerated {
                let title = weather.location ?? ""
                let temperature = weather.temperatureCelsius ?? 0
                let humidity = weather.humidityPercent ?? 0
                let advice = weather.advice ?? ""
                let condition = weather.condition?.rawValue
                messages[messageIndex].text = "\(title)\nTemperature: \(temperature)\nHumidity: \(humidity)\n\( condition ?? "")\n\(advice)"
            }
            else if let travel = partial.content as? TravelModel.PartiallyGenerated {
                messages[messageIndex].text = travel.formattedSummary
            }
        }
    }

    private func scrollToBottom(proxy: ScrollViewProxy) {
        withAnimation(.easeOut(duration: 0.25)) {
            if isTyping {
                proxy.scrollTo("typing_indicator", anchor: .bottom)
            } else if let lastId = messages.last?.id {
                proxy.scrollTo(lastId, anchor: .bottom)
            }
        }
    }
}

#Preview {
    PromptView<WeatherModel>(instructions: "", navTitle: "")
}
