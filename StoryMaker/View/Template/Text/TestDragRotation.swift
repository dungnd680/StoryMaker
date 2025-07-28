////
////  TestDragRotation.swift
////  StoryMaker
////
////  Created by devmacmini on 25/7/25.
////
//
//import SwiftUI
//
//struct TestDragRotation: View {
//    @State private var angle: CGFloat = 0
//    @State private var lastAngle: CGFloat = 0
//    @State private var width : CGFloat = 200
//    @State private var height : CGFloat = 100
//    @State private var imageOffset: CGSize = .zero
//    
//    @State var setupValueOnDrag = false
//    
//    var body: some View {
//        ZStack {
//            Text("Double Tap To Edit")
//                .frame(width: width, height: height)
//                .background(.gray.opacity(0.5))
//                .offset(x: 0, y: 0)
//                .rotationEffect(.degrees(Double(self.angle)))
//                 
//            let imageOffsetX = -width / 2
//            let imageOffsetY = height / 2
//            let radians = angle * .pi / 180
//
//            let rotatedX = imageOffsetX * cos(radians) - imageOffsetY * sin(radians)
//            let rotatedY = imageOffsetX * sin(radians) + imageOffsetY * cos(radians)
//
//            Image("Rotate Text Box")
//                .offset(x: rotatedX, y: rotatedY)
//                .gesture(DragGesture()
//                    .onChanged { v in
//                        if !setupValueOnDrag {
//                            let imageOffsetX = -width / 2
//                            let imageOffsetY = height / 2
//                            let radians = angle * .pi / 180
//
//                            let rotatedStartX = imageOffsetX * cos(radians) - imageOffsetY * sin(radians)
//                            let rotatedStartY = imageOffsetX * sin(radians) + imageOffsetY * cos(radians)
//
//                            imageOffset = CGSize(width: rotatedStartX, height: rotatedStartY)
//                            setupValueOnDrag = true
//                        }
//
//                        let ax = imageOffset.width
//                        let ay = imageOffset.height
//                        let bx = ax + v.translation.width
//                        let by = ay + v.translation.height
//
//                        let a = sqrt(pow(v.translation.width, 2) + pow(v.translation.height, 2))
//                        let b = sqrt(ax * ax + ay * ay)
//                        let c = sqrt(bx * bx + by * by)
//
//                        let cosTheta = (b * b + c * c - a * a) / (2 * b * c)
//                        let clampedCosTheta = max(-1.0, min(1.0, cosTheta))
//                        let thetaRad = acos(clampedCosTheta)
//                        var thetaDeg = thetaRad * 180 / .pi
//
//                        let cross = ax * by - ay * bx
//                        if cross < 0 { thetaDeg = -thetaDeg }
//
//                        self.angle = self.lastAngle + thetaDeg
//                    }
//                    .onEnded { v in
//                        self.lastAngle = self.angle
//                        setupValueOnDrag = false
//                    }
//                )
//        }
//    }
//}
//
//#Preview {
//    TestDragRotation()
//}
