//
//  MessageBubble.swift
//  FoundationCheck
//
//  Created by karthik kumar Choppavarapu on 21/11/26.
//

import SwiftUI

struct MessageBubble: View {
    let message: PromptMessage

    var body: some View {
        HStack {
            if message.isUser { Spacer(minLength: 50) }

            Text(message.text)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(message.isUser ? Color.blue : Color(.lightGray))
                .foregroundStyle(message.isUser ? .white : .primary)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))

            if !message.isUser { Spacer(minLength: 50) }
        }
    }
}

#Preview {
    MessageBubble(message: PromptMessage(text: "Hi User! How can I help you today?", isUser: false))
}
