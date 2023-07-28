//
//  SwiftUIImageZoomViewer.swift
//  PinImageToImageTest
//
//  Created by Gakkie Gakkienl on 18/07/2023.
//
// Adapted from:
// https://github.com/fuzzzlove/swiftui-image-viewer

import SwiftUI

public struct SwiftUIImageZoomViewer: View {

    private let image: UIImage
    
    private var minScale: CGFloat = 1.0
    private var maxScale: CGFloat = 5.0

    @State private var scale: CGFloat = 1
    @State private var lastScale: CGFloat = 1

    @State private var offset: CGPoint = .zero
    @State private var lastTranslation: CGSize = .zero
    
    // Pin(s)
    @State private var tapLocation = CGPoint.zero

    public init(image: UIImage) {
        self.image = image
    }

    public var body: some View {
        GeometryReader { proxy in
            ScrollView([.horizontal, .vertical], showsIndicators: false) {
                ZStack {
                    Image(uiImage: image)
                        .resizable()
//                        .fixedSize()
                        .aspectRatio(contentMode: .fit)
                    
                    // Test Pin at tapLocation
                    mapImagePinSmall()
                        .foregroundColor(.green)
                        .position(tapLocation)
                    
                    // Test Pins @ fixed (stored) location
                    mapImagePinSmall()
                        .foregroundColor(.red)
                        .position(x: 776, y: 1150)
                    
                    mapImagePinSmall()
                        .foregroundColor(.blue)
                        .position(x: 1178, y: 1317)
                }
                .frame(width: image.size.width, height: image.size.height)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .scaleEffect(scale)
            .offset(x: offset.x, y: offset.y)
            .gesture(makeDragGesture(size: proxy.size))
            .gesture(makeMagnificationGesture(size: proxy.size))
            // get location for pin
            .onTapGesture { location in
                print("LOCATION", location)
            }
            .gesture(makeLongPressGestureWithDragForLocation(size: image.size))
            .onAppear {
                print("Image Size ", image.size)
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
                
                // Added min/max scale
                if scale < minScale {
                    withAnimation {
                        scale = minScale
                    }
                } else if scale > maxScale {
                    withAnimation {
                        scale = maxScale
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
    
    // Try and get the location where the user Long Pressed
    private func makeLongPressGestureWithDragForLocation(size: CGSize) -> some Gesture {
        LongPressGesture(minimumDuration: 0.75).sequenced(before: DragGesture(minimumDistance: 0, coordinateSpace: .local))
            .onEnded { value in
                switch value {
                case .second(true, let drag):
                    let location = drag?.location ?? .zero
                    let correctedLocation = CGPoint(x: location.x  + offset.x, y: location.y + offset.y)
                    //let correctedLocation = CGPoint(x: location.x / scale, y: location.y / scale)
                    
                    print("Offset", offset)
                    print("Drag Location", location)
                    print("Scale: \(scale)")
                    print("Last Scale: \(lastScale)")
                    print("Corrected location: \(correctedLocation)")
                    tapLocation = correctedLocation
                    //tapLocation = location   // capture location !!
                default:
                    break
                }
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
}

struct SwiftUIImageZoomViewer_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIImageZoomViewer(image: UIImage(named: "worldMap")!)
    }
}
