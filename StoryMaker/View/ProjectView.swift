//
//  ProjectsView.swift
//  StoryMaker
//
//  Created by devmacmini on 1/8/25.
//

import SwiftUI

struct ProjectPreview: Identifiable {
    var id: String { name }
    var name: String
    var imageURL: URL
    var thumbURL: URL
    var lastModified: Date
}

struct ProjectView: View {
    
    @State private var showTemplate: Bool = false
    @State private var showSubscription: Bool = false
    @State private var selectedImageURL: URL? = nil
    @State private var projects: [ProjectPreview] = []
    @State private var showDeleteAlert = false
    @State private var projectToDelete: ProjectPreview? = nil
    
    @StateObject private var projectViewModel = ProjectViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Image(systemName: "inset.filled.leftthird.rectangle.portrait")
                        .resizable()
                        .frame(width: 20, height: 20)
                    
                    Spacer()
                    
                    Image(systemName: "magnifyingglass")
                        .resizable()
                        .frame(width: 22, height: 22)
                }
                .padding(.vertical, 8)
                
                ZStack {
                    LinearGradient(
                        gradient: Gradient(colors: [.customOrange, .customRed]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .frame(height: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    
                    HStack {
                        Image("Add Background")
                            .resizable()
                            .frame(width: 35, height: 35)
                        
                        Text("New Project")
                            .fontWeight(.bold)
                            .foregroundStyle(.customWhiteGray)
                    }
                }
                .onTapGesture {
                    selectedImageURL = nil
                    showTemplate = true
                }
                
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 13) {
                        ForEach(projects) { project in
                            ZStack {
                                if let thumb = UIImage(contentsOfFile: project.thumbURL.path) {
                                    Button {
                                        selectedImageURL = project.imageURL
                                        showTemplate = true
                                    } label: {
                                        Image(uiImage: thumb)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 100, height: 150)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                    }
                                }
                                
                                VStack {
                                    HStack {
                                        Spacer()
                                        
                                        Menu {
                                            Button {
                                                selectedImageURL = project.imageURL
                                                showTemplate = true
                                            } label: {
                                                HStack {
                                                    Text("Edit")
                                                    
                                                    Spacer()
                                                    
                                                    Image(systemName: "square.and.pencil")
                                                }
                                            }
                                            
                                            Button {
                                                projectToDelete = project
                                                showDeleteAlert = true
                                            } label: {
                                                HStack {
                                                    Text("Delete")
                                                    
                                                    Spacer()
                                                    
                                                    Image(systemName: "trash")
                                                        .tint(.red)
                                                }
                                            }
                                        } label: {
                                            Image(systemName: "ellipsis.circle")
                                                .tint(.white)
                                                .padding(.trailing, 12)
                                                .padding(.top, 4)
                                        }
                                    }
                                    
                                    Spacer()
                                }
                            }
                        }
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal)
            .alert("Delete this project?", isPresented: $showDeleteAlert) {
                Button("Delete", role: .destructive) {
                    if let project = projectToDelete {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            projectViewModel.deleteProject(named: project.name)
                            projects = projectViewModel.loadAllProjects()
                        }
                    }
                }
                
                Button("Cancel", role: .cancel) {}
            }
            .navigationDestination(isPresented: $showTemplate) {
                if let selectedURL = selectedImageURL,
                   let image = UIImage(contentsOfFile: selectedURL.path) {
                    let name = selectedURL.deletingPathExtension().lastPathComponent
                    let metadata = projectViewModel.loadProjectData(name: name)

                    TemplateView(
                        showSubscription: $showSubscription, projects: $projects, input: TemplateInputData(name: name, image: image, metadata: metadata)
                    )
                } else {
                    TemplateView(showSubscription: $showSubscription, projects: $projects, input: nil)
                }
            }
        }
//        .onAppear {
//            showSubscription = true
//        }
        .onAppear {
            projects = projectViewModel.loadAllProjects()
        }
        .onReceive(NotificationCenter.default.publisher(for: .didExportImage)) { notification in
            if let url = notification.userInfo?["imageURL"] as? URL {
                projectViewModel.savedImageURLs.append(url)
            }
        }
        .fullScreenCover(isPresented: $showSubscription) {
            SubscriptionView()
        }
    }
    
    func loadImage(from url: URL?) -> UIImage? {
        guard let url = url else { return nil }
        return UIImage(contentsOfFile: url.path)
    }
}

#Preview {
    ProjectView()
}
