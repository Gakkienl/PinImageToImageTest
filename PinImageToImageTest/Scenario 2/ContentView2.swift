//
//  ContentView2.swift
//  PinImageToImageTest
//
//  Created by Gakkie Gakkienl on 13/06/2023.
//

/*
 CASE:
        Enable the user tp pin images (symbols) to an Image (pixel coordinates)
        The pins must stay in the correct place when panning and zooming and
        also when the screen estate changes by rotating, or split screen and slide
        over on Ipads. Lastly the pins (symbols) must be tapable!
 SCENARIO 2:
        ContentView2 + SwiftUIImageZoomViewer (adapted)
        Test pins work! Pin at tappedLoaction is placed incorrectly! Somehow the
        coordinates are off?? Pin does stay in the correct location...
 SOLUTION:
        Something to do with scale and offset, but can't figure it out ...
        1418, 1224
 */

import SwiftUI

struct ContentView2: View {
    @State private var mapImage = UIImage(named: "worldMap")!
    @State private var tapLocation = CGPoint.zero
    
    var body: some View {
        SwiftUIImageZoomViewer(image: mapImage)
        
//        ZStack {
//            ScrollView([.horizontal, .vertical], showsIndicators: false){
//                ZStack {
//                    Image(uiImage: mapImage)
//                        .resizable()
//                        .fixedSize()
//
//                    mapImagePinSmall()
//                        .foregroundColor(.green)
//                        .position(tapLocation)
//
//                    mapImagePinSmall()
//                        .foregroundColor(.red)
//                        .position(x: 776, y: 1150)
//
//                    mapImagePinSmall()
//                        .foregroundColor(.blue)
//                        .position(x: 1178, y: 1317)
//                }
//                .onAppear {
//                    print("image size", mapImage.size)
//                }
//                .frame(width: mapImage.size.width, height: mapImage.size.height)
//            }
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//        }
    }
}

struct ContentView2_Previews: PreviewProvider {
    static var previews: some View {
        ContentView2()
    }
}
