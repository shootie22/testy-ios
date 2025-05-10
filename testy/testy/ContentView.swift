//
//  ContentView.swift
//  testy
//
//  Created by Radu Nenu on 09/05/2025.
//

import SwiftUI

struct SideMenuView: View {
    let squareCount = 10
    let squareSize: CGFloat = 50
    let squareRadius: CGFloat = 10

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(0..<squareCount, id: \.self) { index in
                Rectangle()
                    .fill(Color.purple)
                    .frame(width: squareSize, height: squareSize)
                    .overlay(
                        Text("\(index + 1)")
                            .foregroundColor(.black)
                    )
            }
            Spacer()
        }
        .padding()
        .frame(width: 150)
        .background(Color.green)
    }
}

// --- spaces list ---

struct SpacesListView: View {
    let spacesCount = 20

    var body: some View {
        VStack(spacing: 16) {
            ForEach(0..<spacesCount, id: \.self) { index in
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.purple)
                    .frame(width: 50, height: 50)
                    .overlay(Text("\(index + 1)").foregroundColor(.white))
            }
            Spacer()
        }
        .padding(.top, 20)
        .frame(width: 70)
        .background(Color.black)
    }
}

// --- view constructor ---

struct ContentView: View {
    @State private var dragOffset: CGFloat = 0
    @State private var menuOpen: Bool = false
    @State private var dragProgress: CGFloat = 0
    
    private let menuWidth: CGFloat = 70

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                
                // include components
                SpacesListView()

                // main content
                Color.gray
                    .overlay(
                        List(0 ..< 10) { item in
                            Text("room entries")
                                .font(.largeTitle)
                                .padding()
                        }
                    )
                    .offset(x: dragOffset)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let newOffset = value.translation.width
                                dragProgress = newOffset
                                if newOffset > 0 || menuOpen {
                                    dragOffset = min(menuWidth, max(0, menuOpen ? menuWidth + newOffset : newOffset))
                                }
                            }
                            .onEnded { value in
                                withAnimation(.easeOut) {
                                    if value.translation.width > 100 {
                                        dragOffset = menuWidth
                                        menuOpen = true
                                    } else if value.translation.width < -100 {
                                        dragOffset = 0
                                        menuOpen = false
                                    } else {
                                        dragOffset = menuOpen ? menuWidth : 0
                                    }
                                }
                            }
                    )
                    .animation(.easeOut, value: dragOffset)
            }
        }
    }
}


#Preview {
    ContentView()
}
