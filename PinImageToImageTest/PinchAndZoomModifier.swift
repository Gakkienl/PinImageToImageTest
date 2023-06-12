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
    
    // Try and get the location where the user Long Pressed
    private var longPressGestureWithDragForLocation: some Gesture {
        LongPressGesture(minimumDuration: 0.75).sequenced(before: DragGesture(minimumDistance: 0, coordinateSpace: .local))
            .onEnded { value in
                switch value {
                case .second(true, let drag):
                    let correctedLocation = CGPoint(
                                                    x: (drag?.location.x ?? .zero) / currentScale,
                                                    y: (drag?.location.y ?? .zero) / currentScale
                                                    )
                    print("Drag Location", drag?.location ?? .zero)
                    print("Current scale: \(currentScale)")
                    print("Corrected location: \(correctedLocation)")
                    tapLocation = correctedLocation   // capture location !!
                default:
                    break
                }
            }
    }
    
    func body(content: Content) -> some View {
        ScrollView([.horizontal, .vertical]) {
            content
                .frame(width: contentSize.width * currentScale, height: contentSize.height * currentScale, alignment: .center)
                .modifier(PinchToZoom(minScale: min, maxScale: max, scale: $currentScale))
//                .onTapGesture { location in
//                    let correctedLocation = CGPoint(x: location.x / currentScale, y: location.y / currentScale)
//                    print("Tapped at \(location)", "Current scale: \(currentScale)")
//                    print("Corrected location for Scale: \(correctedLocation)")
//                    tapLocation = correctedLocation
//                }
                //.simultaneousGesture(longPressGestureWithDragForLocation)
                .simultaneousGesture(doubleTapGesture)
        }
        .animation(.easeInOut, value: currentScale)
    }
}

// THREE
class PinchZoomView: UIView {
    let minScale: CGFloat
    let maxScale: CGFloat
    var isPinching: Bool = false
    var scale: CGFloat = 1.0
    let scaleChange: (CGFloat) -> Void
    
    var longPressLocation = CGPoint.zero
    
    init(minScale: CGFloat,
           maxScale: CGFloat,
         currentScale: CGFloat,
         scaleChange: @escaping (CGFloat) -> Void) {
        self.minScale = minScale
        self.maxScale = maxScale
        self.scale = currentScale
        self.scaleChange = scaleChange
        super.init(frame: .zero)
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinch(gesture:)))
        pinchGesture.cancelsTouchesInView = false
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPress(gesture:)))
        addGestureRecognizer(pinchGesture)
        addGestureRecognizer(longPressGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    @objc private func longPress(gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .ended:
            longPressLocation = gesture.location(in: self)
            print("Long Pressed in UIView on \(longPressLocation) with scale \(scale)")
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

// TWO
struct PinchZoom: UIViewRepresentable {
    let minScale: CGFloat
    let maxScale: CGFloat
    @Binding var scale: CGFloat
    @Binding var isPinching: Bool
    
    func makeUIView(context: Context) -> PinchZoomView {
        let pinchZoomView = PinchZoomView(minScale: minScale, maxScale: maxScale, currentScale: scale, scaleChange: { scale = $0 })
        return pinchZoomView
    }
    
    func updateUIView(_ pageControl: PinchZoomView, context: Context) { }
}

// ONE
struct PinchToZoom: ViewModifier {
    let minScale: CGFloat
    let maxScale: CGFloat
    @Binding var scale: CGFloat
    @State var anchor: UnitPoint = .center
    @State var isPinching: Bool = false
    
    func body(content: Content) -> some View {
        ZStack {
            content
                .scaleEffect(scale, anchor: anchor)
                .animation(.spring(), value: isPinching)
                .overlay(PinchZoom(minScale: minScale, maxScale: maxScale, scale: $scale, isPinching: $isPinching))
        }
    }
}
