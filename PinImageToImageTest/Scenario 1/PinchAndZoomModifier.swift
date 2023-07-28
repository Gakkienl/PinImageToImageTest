//
//  PinchAndZoomModifier.swift
//  PinImageToImageTest
//
//  Created by Gakkie Gakkienl on 03/06/2023.
//
// Adapted from:
// https://medium.com/@priya_talreja/pinch-zoom-pan-image-and-double-tap-to-zoom-image-in-swiftui-878ca70c539d
// https://github.com/talreja-priya/PinchZoom

import SwiftUI
import UIKit

extension View {
    func PinchToZoomAndPan(contentSize: CGSize, tapLocation: Binding<CGPoint>) -> some View {
        modifier(PinchAndZoomModifier(contentSize: contentSize, tapLocation: tapLocation))
    }
}

struct PinchAndZoomModifier: ViewModifier {
    private var contentSize: CGSize
    private var min: CGFloat = 0.75 // 1.0
    private var max: CGFloat = 3.0
    @State var currentScale: CGFloat = 1.0
    
    // The location in the Image frame the user long pressed
    // to send back to the calling View
    @Binding var tapLocation: CGPoint

    init(contentSize: CGSize, tapLocation: Binding<CGPoint>) {
        self.contentSize = contentSize
        self._tapLocation = tapLocation
        print("ContentSize: \(self.contentSize)")
    }
    
    var doubleTapGesture: some Gesture {
        TapGesture(count: 2).onEnded {
            currentScale = 1.0
//            if currentScale <= min { currentScale = max } else
//            if currentScale >= max { currentScale = min } else {
//                currentScale = ((max - min) * 0.5 + min) < currentScale ? max : min
//            }
        }
    }
    
    func body(content: Content) -> some View {
        ScrollView([.horizontal, .vertical]) {
            content
                .frame(width: contentSize.width * currentScale, height: contentSize.height * currentScale, alignment: .center)
                .modifier(PinchToZoom(minScale: min, maxScale: max, scale: $currentScale, longPressLocation: $tapLocation))
//                .onTapGesture { location in
//                    let correctedLocation = CGPoint(x: location.x / currentScale, y: location.y / currentScale)
//                    print("Tapped at \(location)", "Current scale: \(currentScale)")
//                    print("Corrected location for Scale: \(correctedLocation)")
//                    tapLocation = correctedLocation
//                }
        }
        .animation(.easeInOut, value: currentScale)
    }
}

// THREE; Pinch and zoom View to embed in SwiftUI View
class PinchZoomView: UIView {
    let minScale: CGFloat
    let maxScale: CGFloat
    var isPinching: Bool = false
    var scale: CGFloat = 1.0
    let scaleChange: (CGFloat) -> Void
    let location: (CGPoint) -> Void
    
    private var longPressLocation = CGPoint.zero
    
    init(minScale: CGFloat, maxScale: CGFloat, currentScale: CGFloat, scaleChange: @escaping (CGFloat) -> Void, location: @escaping (CGPoint) -> Void) {
        self.minScale = minScale
        self.maxScale = maxScale
        self.scale = currentScale
        self.scaleChange = scaleChange
        self.location = location
        super.init(frame: .zero)
        
        // Gestures
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinch(gesture:)))
        pinchGesture.cancelsTouchesInView = false
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPress(gesture:)))
        addGestureRecognizer(pinchGesture)
        addGestureRecognizer(longPressGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // location where the user long pressed, to set a pin in the calling View
    // Needs to be corrected for the current zoom scale!
    @objc private func longPress(gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .ended:
            longPressLocation = gesture.location(in: self)
            let correctedLocation = CGPoint(x: longPressLocation.x / scale, y: longPressLocation.y / scale)
            location(correctedLocation)
            print("Long Pressed in UIView on \(longPressLocation) with scale \(scale)")
            print("Correct location for scale: \(correctedLocation)")
        default:
            break
        }
    }
    
    @objc private func pinch(gesture: UIPinchGestureRecognizer) {
        switch gesture.state {
        case .began:
            isPinching = true
            
        case .changed, .ended:
            if gesture.scale <= minScale {
                scale = minScale
            } else if gesture.scale >= maxScale {
                scale = maxScale
            } else {
                scale = gesture.scale
            }
            scaleChange(scale)
        case .cancelled, .failed:
            isPinching = false
            scale = 1.0
        default:
            break
        }
    }
}

// TWO: Bridge UIView to SwiftUI
struct PinchZoom: UIViewRepresentable {
    let minScale: CGFloat
    let maxScale: CGFloat
    @Binding var scale: CGFloat
    @Binding var isPinching: Bool
    
    @Binding var longPressLocation: CGPoint
    
    func makeUIView(context: Context) -> PinchZoomView {
        let pinchZoomView = PinchZoomView(minScale: minScale, maxScale: maxScale, currentScale: scale, scaleChange: { scale = $0 }, location: { longPressLocation = $0 })
        return pinchZoomView
    }
    
    func updateUIView(_ pageControl: PinchZoomView, context: Context) { }
}

// ONE; Modifier to use the UIKit View
struct PinchToZoom: ViewModifier {
    let minScale: CGFloat
    let maxScale: CGFloat
    @Binding var scale: CGFloat
    @State var anchor: UnitPoint = .center
    @State var isPinching: Bool = false
    
    @Binding var longPressLocation: CGPoint
    
    func body(content: Content) -> some View {
        ZStack {
            content
                .scaleEffect(scale, anchor: anchor)
                .animation(.spring(), value: isPinching)
                .overlay(
                    PinchZoom(minScale: minScale, maxScale: maxScale, scale: $scale, isPinching: $isPinching, longPressLocation: $longPressLocation)
                        // False disables pinch and long press on the overlay, true makes the buttons no longer tap-able
                        //.allowsHitTesting(false)
                )
        }
    }
}
