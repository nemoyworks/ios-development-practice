//
//  ContentView.swift
//  Animations
//
//  Created by Ростислав Гайда on 08.06.2026.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var dragAmount = CGSize(width: 0, height: -300)
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            RadialGradient(colors: [.blue, .black], center: .center, startRadius: 10, endRadius: 150)
                .frame(width: 300, height: 200)
                .clipShape(.rect(cornerRadius: 10))
            
            Text("NEMOY WORKS")
                .font(.headline.weight(.heavy))
                .foregroundColor(.white)
                .offset(x: -10, y: -10)
        }
        .offset(dragAmount)
        .gesture(
            DragGesture()
                .onChanged {
                    dragAmount = CGSize(
                    width: 0 + $0.translation.width,
                    height: -300 + $0.translation.height)
                }
                .onEnded { _ in
                    withAnimation(.bouncy) {
                        dragAmount = CGSize(width: 0, height: -300)
                    }
                }
        )
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
