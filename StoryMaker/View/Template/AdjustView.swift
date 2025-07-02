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

struct AdjustView: View {
    @Binding var lightness: Double
    @Binding var saturation: Double
    @Binding var blur: Double
    @Binding var selectedImage: UIImage?
    @Binding var selectedFilter: FiltersModel
    
    @State private var showBackgroundPicker = false
    @State private var selectedTab: AdjustTab = .brightness
    
    var onClose: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            VStack {
                ZStack {
                    Text(selectedTab == .brightness ? "Brightness" : "Filters")
                        .font(.headline)
                    
                    HStack {
                        Spacer()
                        
                        Button {
                            onClose()
                        } label: {
                            Image("Done")
                        }
                        .padding(.trailing)
                    }
                }
                .padding(.vertical)
                
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
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .padding(.bottom)
                
                if selectedTab == .brightness {
                    BrightnessView(lightness: $lightness, saturation: $saturation, blur: $blur)
                } else if selectedTab == .filters {
                    FiltersView(selectedFilter: $selectedFilter, originalImage: selectedImage ?? UIImage())
                }
            }
            .background(Color.white)
        }
        .sheet(isPresented: $showBackgroundPicker) {
            BackgroundPickerView { image in
                selectedImage = image
            }
        }
    }
}

struct FiltersView: View {
    @Binding var selectedFilter: FiltersModel
    
    var originalImage: UIImage
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(filters) { filter in
                    VStack {
                        Image(uiImage: applyFilter(filter, to: originalImage))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 60, height: 60)
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                            .overlay(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(selectedFilter.id == filter.id ? Color.red.opacity(0.9) : .clear, lineWidth: 2)
                            )

                        Text(filter.name)
                            .font(.caption)
                            .foregroundColor(selectedFilter.id == filter.id ? Color.red.opacity(0.9) : .gray)
                    }
                    .onTapGesture {
                        selectedFilter = filter
                    }
                }
            }
            .padding(.horizontal, 8)
            .padding(.top)
        }
    }
}

struct BrightnessView: View {
    @Binding var lightness: Double
    @Binding var saturation: Double
    @Binding var blur: Double
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Lightness")
                .font(.caption)
            HStack {
                Slider(value: $lightness, in: -100...100, step: 1)
                    .tint(.colorRed)
                Text(String(format: "%.0f", lightness))
                    .frame(width: 32)
            }
            .font(.subheadline)
            .padding(.top, -12)
            
            Text("Saturation")
                .font(.caption)
            HStack {
                Slider(value: $saturation, in: -100...100, step: 1)
                    .tint(.colorRed)
                Text(String(format: "%.0f", saturation))
                    .frame(width: 32)
            }
            .font(.subheadline)
            .padding(.top, -12)
            
            Text("Blur")
                .font(.caption)
            HStack {
                Slider(value: $blur, in: 0...100, step: 1)
                    .tint(.colorRed)
                Text(String(format: "%.0f", blur))
                    .frame(width: 32)
            }
            .font(.subheadline)
            .padding(.top, -12)
        }
        .padding(.leading, 26)
        .padding(.trailing)
    }
}

#Preview {
    AdjustView(
        lightness: .constant(0),
        saturation: .constant(0),
        blur: .constant(0),
        selectedImage: .constant(nil),
        selectedFilter: .constant(filters[0]),
        onClose: {}
    )
}
