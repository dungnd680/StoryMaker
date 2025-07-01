//
//  BackgroundFilter.swift
//  StoryMaker
//
//  Created by devmacmini on 1/7/25.
//

import SwiftUI

struct BrightnessView: View {
    @Binding var lightness: Double
    @Binding var saturation: Double
    @Binding var blur: Double
    @Binding var selectedImage: UIImage?
    
    @State private var showBackgroundPicker = false
    
    var onClose: () -> Void
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Button {
                        showBackgroundPicker = true
                    } label: {
                        Image("Edit Background")
                    }
                    
                    Button {
                        
                    } label: {
                        Image("Filters")
                            .padding(.horizontal, 30)
                    }

                    Button {
                        
                    } label: {
                        Image("Adjust")
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 30)
                .background(Color.gray.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 25))
                
                VStack(alignment: .leading) {
                    Text("Lightness")
                        
                    HStack {
                        Slider(value: $lightness, in: -100...100, step: 1)
                            .tint(.colorRed)
                        Text(String(format: "%.0f", lightness))
                            .frame(width: 32)
                    }
                    .padding(.top, -12)
                    
                    Text("Saturation")
                    HStack {
                        Slider(value: $saturation, in: -100...100, step: 1)
                            .tint(.colorRed)
                        Text(String(format: "%.0f", saturation))
                            .frame(width: 32)
                    }
                    .padding(.top, -12)
                    
                    Text("Blur")
                    HStack {
                        Slider(value: $blur, in: 0...100, step: 1)
                            .tint(.colorRed)
                        Text(String(format: "%.0f", blur))
                            .frame(width: 32)
                    }
                    .padding(.top, -12)
                }
                .font(.subheadline)
            }
            .padding(.horizontal)
            .navigationTitle("Brightness")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        onClose()
                    } label: {
                        Image("Done")
                    }
                }
            }
            .sheet(isPresented: $showBackgroundPicker) {
                BackgroundPickerView { image in
                    selectedImage = image
                    showBackgroundPicker = false
                }
            }
        }
        .frame(height: UIScreen.main.bounds.height * 0.30)
    }
}

#Preview {
    BrightnessView(
        lightness: .constant(0),
        saturation: .constant(0),
        blur: .constant(0),
        selectedImage: .constant(nil),
        onClose: {}
    )
}
