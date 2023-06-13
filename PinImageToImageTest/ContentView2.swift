//
//  ContentView2.swift
//  PinImageToImageTest
//
//  Created by Gakkie Gakkienl on 13/06/2023.
//

//
//  ContentView.swift
//  PinImageToImageTest
//
//  Created by Gakkie Gakkienl on 03/06/2023.
//

import SwiftUI

struct ContentView2: View {
    @State private var mapImage = UIImage(named: "worldMap")!
    @State private var tapLocation = CGPoint.zero
    
    @State private var currentScale: CGFloat = 0.0
    @State private var finalScale: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            ScrollView([.horizontal, .vertical], showsIndicators: false){
                ZStack {
                    Image(uiImage: mapImage)
                        .resizable()
                        .fixedSize()
                    
                    mapImagePinSmall()
                        .foregroundColor(.green)
                        .position(tapLocation)
                    
                    mapImagePinSmall()
                        .foregroundColor(.red)
                        .position(x: 776, y: 1150)
                    
                    mapImagePinSmall()
                        .foregroundColor(.blue)
                        .position(x: 1178, y: 1317)
                }
                .onAppear {
                    print("image size", mapImage.size)
                }
                .frame(width: mapImage.size.width, height: mapImage.size.height)
                .scaleEffect(finalScale)
                .gesture(
                    MagnificationGesture().onChanged { newScale in
                        currentScale = newScale
                    }
                    .onEnded { scale in
                        finalScale = scale
                        currentScale = 0
                    }
                )
                // Empty onTapGesture before needed to prevent longPressWithDrag from disabling scrolling!!
                .onTapGesture { }
                .gesture(longPressGestureWithDragForLocation)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    // Try and get the location where the user Long Pressed
    private var longPressGestureWithDragForLocation: some Gesture {
        LongPressGesture(minimumDuration: 0.75).sequenced(before: DragGesture(minimumDistance: 0, coordinateSpace: .local))
            .onEnded { value in
                switch value {
                case .second(true, let drag):
                    let location = drag?.location ?? .zero
                    let correctedLocation = CGPoint(
                        x: (drag?.location.x ?? .zero) / finalScale,
                        y: (drag?.location.y ?? .zero) / finalScale
                    )
                    
                    print("Drag Location", location)
                    print("Current scale: \(currentScale)")
                    print("Final scale: \(finalScale)")
                    print("Corrected location: \(correctedLocation)")
                    tapLocation = location   // capture location !!
                default:
                    break
                }
            }
    }

}

struct ContentView2_Previews: PreviewProvider {
    static var previews: some View {
        ContentView2()
    }
}
