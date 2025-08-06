////
////  SwiftUIView.swift
////  StoryMaker
////
////  Created by devmacmini on 5/8/25.
////
//
//import SwiftUI
//
//struct SwiftUIView: View {
//    
//    @StateObject var project: Project = Project()
//    @StateObject var editorVM: EditorVM = EditorVM()
//    
//    var body: some View {
//        ZStack {
//            Color.gray.ignoresSafeArea()
//            
//            VStack {
//                ScrollView(.vertical, showsIndicators: false) {
//                    ForEach(project.texts, id: \.self) { text in
//                        Text(text)
//                            .font(.largeTitle)
//                            .foregroundStyle(.white)
//                            .onTapGesture {
//                                project.textSelected = text
//                                editorVM.activeToolGroup = .text
//                            }
//                    }
//                }
//                
//                Spacer()
//                Button {
//                    project.newText()
//                } label: {
//                    Text("Add")
//                        .font(.title)
//                }
//            }
//        }
//    }
//}
//
//#Preview {
//    SwiftUIView()
//}
//
//class Project: ObservableObject {
//    @Published var id: String = UUID().uuidString
//    @Published var texts: [String] = []
//    @Published var textSelected: String = ""
//    
//    func newText() {
//        let text = "123"
//        texts.append(text)
//    }
//    
//    func delete() {
//        
//    }
//}
//
//enum EditorToolGroup {
//    
//    case none
//    case text
//    case filter
//    case bg
//}
//
//class EditorVM: ObservableObject {
//    @Published var activeToolGroup: EditorToolGroup = .none
//}
