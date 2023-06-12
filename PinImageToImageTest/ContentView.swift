//
//  ContentView.swift
//  PinImageToImageTest
//
//  Created by Gakkie Gakkienl on 03/06/2023.
//

import SwiftUI

let arrowPointUp = Image(systemName: "arrowtriangle.up.fill")

struct ContentView: View {
    @State private var mapImage = UIImage(named: "worldMap")!
    @State private var tapLocation = CGPoint.zero
    @State private var height = 0.0
    @State private var width = 0.0

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Image(uiImage: mapImage)
                    .resizable()
                    .fixedSize()
                
                arrowPointUp
                    .foregroundColor(.green)
                    .position(tapLocation)
                
                arrowPointUp
                    .foregroundColor(.red)
                    .position(x: 776, y: 1150)

                arrowPointUp
                    .foregroundColor(.blue)
                    .position(x: 1178, y: 1317)
            }
            .onAppear {
                height = Double(mapImage.size.height)
                width = Double(mapImage.size.width)
                print("image", height, width)
            }
            //.frame(width: proxy.size.width, height: proxy.size.height)
            .frame(width: mapImage.size.width, height: mapImage.size.height)
//            .scaledToFit()
//            .clipShape(Rectangle())
            //.PinchToZoomAndPan(contentSize: CGSize(width: proxy.size.width, height: proxy.size.height), tapLocation: $tapLocation)
            .PinchToZoomAndPan(contentSize: mapImage.size, tapLocation: $tapLocation)
//            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
