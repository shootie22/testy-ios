//
//  ContentView.swift
//  testy
//
//  Created by Radu Nenu on 09/05/2025.
//

import SwiftUI

// --- spaces list ---

struct SpacesListView: View {
    let spacesCount = 20

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(0..<spacesCount, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color.purple)
                        .frame(width: 50, height: 50)
                        .overlay(Text("\(index + 1)").foregroundColor(.white))
                }
                Spacer(minLength: 0)
            }
            .padding(.top, 20)
            .frame(maxWidth: .infinity)
        }
        .frame(width: 70)
        .background(Color.black.opacity(0.95))
    }
}

// -- rooms list ---

struct RoomsListView: View {
    let roomsCount = 30

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(0..<roomsCount, id: \.self) { index in
                    RoomEntryView(
                        title: "Room \(index + 1)",
                        lastMessage: "Last message preview..."
                    )
                }
                Spacer(minLength: 0)
            }
            .padding(.top, 20)
            .padding(.horizontal, 0) // no horizontal padding
        }
        .background(Color.black)
    }
}


struct RoomEntryView: View {
    let title: String
    let lastMessage: String

    var body: some View {
        ZStack {
            // bg card
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color.white.opacity(0.1))
                .frame(height: 70)

            HStack(spacing: 8) {
                // circular room avatar, to be replaced with room avatars
                Circle()
                    .fill(Color.green)
                    .frame(width: 40, height: 40)

                // title and message
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.white)
                        .lineLimit(1)

                    Text(lastMessage)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                        .lineLimit(1)
                }

                Spacer()
            }
            .padding(.horizontal, 8)
        }
    }
}

// nice little extension
extension Color {
    func darker() -> Color {
        return self.opacity(0.8)
    }
}

// --- view constructor ---

struct ContentView: View {
    @State private var dragOffset: CGFloat = 0
    @State private var menuOpen: Bool = false
    @State private var dragProgress: CGFloat = 0
    
    private let spacePanelWidth: CGFloat = 70
    private let roomPanelWidth: CGFloat = 150
    private var totalMenuWidth: CGFloat { spacePanelWidth + roomPanelWidth }


    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                HStack(spacing: 0) {
                    SpacesListView()
                        .frame(width: spacePanelWidth)
                    
                    RoomsListView()
                        .frame(width: roomPanelWidth)
                }
                .frame(width: totalMenuWidth)



                // main content
                Color.black.opacity(0.9)
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
                                    dragOffset = min(totalMenuWidth, max(0, menuOpen ? totalMenuWidth + newOffset : newOffset))
                                }

                            }
                            .onEnded { value in
                                withAnimation(.easeOut) {
                                    if value.translation.width > 100 {
                                        dragOffset = totalMenuWidth
                                        menuOpen = true
                                    } else if value.translation.width < -100 {
                                        dragOffset = 0
                                        menuOpen = false
                                    } else {
                                        dragOffset = menuOpen ? totalMenuWidth : 0
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
