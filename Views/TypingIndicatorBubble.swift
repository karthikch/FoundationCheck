//
//  TypingIndicatorBubble.swift
//  FoundationCheck
//
//  Created by karthik kumar Choppavarapu on 21/11/26.
//

import SwiftUI

struct TypingIndicatorBubble: View {
    var body: some View {
        HStack {
            HStack(spacing: 4) {
                ForEach(0..<3, id: \.self) { _ in
                    Circle()
                        .fill(Color.secondary)
                        .frame(width: 7, height: 7)
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(Color(.lightGray))
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))

            Spacer()
        }
    }
}

#Preview {
    TypingIndicatorBubble()
}
