//
//  ContentView3.swift
//  PinImageToImageTest
//
//  Created by Gakkie Gakkienl on 18/07/2023.
//

/*
 CASE:
        Enable the user tp pin images (symbols) to an Image (pixel coordinates)
        The pins must stay in the correct place when panning and zooming and
        also when the screen estate changes by rotating, or split screen and slide
        over on Ipads. Lastly the pins (symbols) must be tapable!
 SCENARIO 3:
        ContentView3 (ScrollView / custom)
        Works at scale = 1, pins stay in place! Also when zooming out (< 1). Pins are not placed
        in the correct place when zooming in (under finger), also (all) pins disappear when zooming in?
        Zooming out again displays the pins in the correct place (both the test pins and at the taplocation?
        Zooming is very erratic & non responsive (not smooth) ...
 SOLUTION:
        Get pinch and zoom to work without breaking anything .... ???
 */

import SwiftUI

struct ContentView3: View {
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
                .onAppear {
                    print("image size", mapImage.size)
                }
                .frame(width: mapImage.size.width * finalScale, height: mapImage.size.height * finalScale)
                .scaleEffect(finalScale)
                .gesture(
                    MagnificationGesture().onChanged { newScale in
                        withAnimation {
                            currentScale = newScale
                        }
                    }
                    .onEnded { scale in
                        withAnimation {
                            finalScale = scale
                            currentScale = 0
                        }
                    }
                )
                .onTapGesture { //location in
                    //print("Location ", location)
                }
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
                    tapLocation = correctedLocation   // capture location !!
                default:
                    break
                }
            }
    }
}

struct ContentView3_Previews: PreviewProvider {
    static var previews: some View {
        ContentView3()
    }
}
