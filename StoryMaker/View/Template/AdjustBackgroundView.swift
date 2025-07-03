//
//  BackgroundFilter.swift
//  StoryMaker
//
//  Created by devmacmini on 1/7/25.
//

import SwiftUI

enum AdjustTab {
    case brightness
    case filters
}

struct AdjustBackgroundView: View {
    @Binding var lightness: Double
    @Binding var saturation: Double
    @Binding var blur: Double
    @Binding var selectedImage: UIImage?
    @Binding var selectedFilter: FiltersModel
    @Binding var filteredThumbnails: [UUID: UIImage]
    @Binding var isVisible: Bool

    @State private var showBackgroundPicker = false
    @State private var selectedTab: AdjustTab = .filters
    
    var tabHeight: [AdjustTab : CGFloat] = [
        .brightness: 280,
        .filters: 260
    ]
    
    var onClose: () -> Void

    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 0) {
                ZStack {
                    Text(selectedTab == .brightness ? "Brightness" : "Filters")
                        .font(.headline)

                    HStack {
                        Spacer()

                        Image("Done")
                            .padding(.trailing)
                            .onTapGesture {
                                onClose()
                            }
                    }
                }
                .frame(height: 50)

                HStack(spacing: 26) {
                    Button {
                        showBackgroundPicker = true
                    } label: {
                        Image("Edit Background")
                    }

                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedTab = .filters
                        }
                    } label: {
                        Image("Filters")
                            .foregroundColor(selectedTab == .filters ? .red.opacity(0.9) : .primary)
                    }

                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedTab = .brightness
                        }
                    } label: {
                        Image("Brightness")
                            .foregroundColor(selectedTab == .brightness ? .red.opacity(0.9) : .primary)
                    }
                }
                .padding(.horizontal, 26)
                .frame(height: 30)
                .background(Color.gray.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 30))

                if selectedTab == .brightness {
                    BrightnessView(lightness: $lightness, saturation: $saturation, blur: $blur)
                } else if selectedTab == .filters {
                    FiltersView(
                        selectedFilter: $selectedFilter,
                        filteredThumbnails: $filteredThumbnails
                    )
                }
            }
            .background(Color.white)
        }
        .offset(y:(isVisible ? 0 : (tabHeight[selectedTab] ?? 300)))
        .animation(.easeInOut(duration: 0.2), value: isVisible)
        .ignoresSafeArea()
        .sheet(isPresented: $showBackgroundPicker) {
            BackgroundPickerView { image in
                selectedImage = image
            }
        }
    }
}

struct FiltersView: View {
    @Binding var selectedFilter: FiltersModel
    @Binding var filteredThumbnails: [UUID: UIImage]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(filters) { filter in
                    VStack {
                        Image(uiImage: filteredThumbnails[filter.id] ?? UIImage())
                            .resizable()
                            .scaledToFill()
                            .frame(width: 60, height: 60)
                            .background(Color.gray.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                            .overlay(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(selectedFilter.id == filter.id ? Color.red.opacity(0.9) : .clear, lineWidth: 2)
                            )

                        Text(filter.name)
                            .font(.caption)
                            .foregroundColor(selectedFilter.id == filter.id ? .red : .gray)
                    }
                    .onTapGesture {
                        selectedFilter = filter
                    }
                }
            }
            .padding(.horizontal, 22)
            .padding(.bottom, 22)
            .frame(height: 180)
        }
    }
}

struct BrightnessView: View {
    @Binding var lightness: Double
    @Binding var saturation: Double
    @Binding var blur: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Lightness")
                .font(.caption)
            HStack {
                Slider(value: $lightness, in: -100...100, step: 1)
                    .tint(.colorRed)
                Text(String(format: "%.0f", lightness))
                    .frame(width: 32)
            }
            .font(.subheadline)

            Text("Saturation")
                .font(.caption)
            HStack {
                Slider(value: $saturation, in: -100...100, step: 1)
                    .tint(.colorRed)
                Text(String(format: "%.0f", saturation))
                    .frame(width: 32)
            }
            .font(.subheadline)

            Text("Blur")
                .font(.caption)
            HStack {
                Slider(value: $blur, in: 0...100, step: 1)
                    .tint(.colorRed)
                Text(String(format: "%.0f", blur))
                    .frame(width: 32)
            }
            .font(.subheadline)
        }
        .padding(.leading, 26)
        .padding(.trailing)
        .padding(.bottom)
        .frame(height: 200)
    }
}

#Preview {
    AdjustBackgroundView(
        lightness: .constant(0),
        saturation: .constant(0),
        blur: .constant(0),
        selectedImage: .constant(nil),
        selectedFilter: .constant(filters[0]),
        filteredThumbnails: .constant([:]),
        isVisible: .constant(true),
        onClose: {}
    )
}
