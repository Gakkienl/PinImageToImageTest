//
//  ContentView4.swift
//  PinImageToImageTest
//
//  Created by Gakkie Gakkienl on 18/07/2023.
//
// Adapted from:
// https://github.com/fuzzzlove/swiftui-image-viewer

/*
 CASE:
        Enable the user tp pin images (symbols) to an Image (pixel coordinates)
        The pins must stay in the correct place when panning and zooming and
        also when the screen estate changes by rotating, or split screen and slide
        over on Ipads. Lastly the pins (symbols) must be tapable!
 SCENARIO 4:
        (Preferred scenario)
        The mostly unmodified version of the above mentioned swiftui-image-viewer.
        The pin at tapLocation works when placed in the default zoom level and stays
        correctly in place when zooming and panning.
        Stored test pins show incorrectly outside off the image
        (point vs pixels? / offset?).
        Placing pins when zoomed in places them incorrectly, not at the tapLocation.
        Pin stays in that spot when zooming and panning!
        .fixedSize() on the Image makes that the test pins are in the correct place,
        But the pan and zoom doesn't work corrcetly (only part of the Image scrollable)
        and placing pin when zommed in puts it at incorrect location
 SOLUTION:
        ???
 */

import SwiftUI

struct ContentView4: View {
    @State private var mapImage = UIImage(named: "worldMap")!
    @State private var tapLocation = CGPoint.zero
    
//    let image: Image
    
    @State private var scale: CGFloat = 1
    @State private var lastScale: CGFloat = 1
    
    @State private var offset: CGPoint = .zero
    @State private var lastTranslation: CGSize = .zero
    
//    public init(image: Image) {
//        self.image = image
//    }
    
    public var body: some View {
        GeometryReader { proxy in
            ZStack {
                Image(uiImage: mapImage)
                    .resizable()
                    //.aspectRatio(contentMode: .fit)
                    .fixedSize()
                
                // Pin at pressed location
                mapImagePinSmall()
                    .foregroundColor(.green)
                    .position(tapLocation)
                
                // Test pins (stored)
                mapImagePinSmall()
                    .foregroundColor(.red)
                    .position(x: 776, y: 1150)
                
                mapImagePinSmall()
                    .foregroundColor(.blue)
                    .position(x: 1178, y: 1317)

            }
            //.frame(maxWidth: .infinity, maxHeight: .infinity)
            //.edgesIgnoringSafeArea(.all)
            .scaleEffect(scale)
            .offset(x: offset.x, y: offset.y)
            .gesture(makeDragGesture(size: mapImage.size))
            .gesture(makeMagnificationGesture(size: mapImage.size))
            .onTapGesture { location in
                print("LOCATION", location)
                tapLocation = location
            }
        }
    }
    
    private func makeMagnificationGesture(size: CGSize) -> some Gesture {
        MagnificationGesture()
            .onChanged { value in
                let delta = value / lastScale
                lastScale = value
                
                // To minimize jittering
                if abs(1 - delta) > 0.01 {
                    scale *= delta
                }
            }
            .onEnded { _ in
                lastScale = 1
                if scale < 1 {
                    withAnimation {
                        scale = 1
                    }
                }
                adjustMaxOffset(size: size)
            }
    }
    
    private func makeDragGesture(size: CGSize) -> some Gesture {
        DragGesture()
            .onChanged { value in
                let diff = CGPoint(
                    x: value.translation.width - lastTranslation.width,
                    y: value.translation.height - lastTranslation.height
                )
                offset = .init(x: offset.x + diff.x, y: offset.y + diff.y)
                lastTranslation = value.translation
            }
            .onEnded { _ in
                adjustMaxOffset(size: size)
            }
    }
    
    private func adjustMaxOffset(size: CGSize) {
        let maxOffsetX = (size.width * (scale - 1)) / 2
        let maxOffsetY = (size.height * (scale - 1)) / 2
        
        var newOffsetX = offset.x
        var newOffsetY = offset.y
        
        if abs(newOffsetX) > maxOffsetX {
            newOffsetX = maxOffsetX * (abs(newOffsetX) / newOffsetX)
        }
        if abs(newOffsetY) > maxOffsetY {
            newOffsetY = maxOffsetY * (abs(newOffsetY) / newOffsetY)
        }
        
        let newOffset = CGPoint(x: newOffsetX, y: newOffsetY)
        if newOffset != offset {
            withAnimation {
                offset = newOffset
            }
        }
        self.lastTranslation = .zero
    }
    
    // Try and get the location where the user Long Pressed
//    private var longPressGestureWithDragForLocation: some Gesture {
//        LongPressGesture(minimumDuration: 0.75).sequenced(before: DragGesture(minimumDistance: 0, coordinateSpace: .local))
//            .onEnded { value in
//                switch value {
//                case .second(true, let drag):
//                    let location = drag?.location ?? .zero
//                    let correctedLocation = CGPoint(
//                        x: (drag?.location.x ?? .zero) / finalScale,
//                        y: (drag?.location.y ?? .zero) / finalScale
//                    )
//                    
//                    print("Drag Location", location)
//                    print("Current scale: \(currentScale)")
//                    print("Final scale: \(finalScale)")
//                    print("Corrected location: \(correctedLocation)")
//                    tapLocation = correctedLocation   // capture location !!
//                default:
//                    break
//                }
//            }
//    }
}

//struct ContentView4_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView4()
//    }
//}
