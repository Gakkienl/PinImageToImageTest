//
//  ContentView.swift
//  PinImageToImageTest
//
//  Created by Gakkie Gakkienl on 03/06/2023.
//

import SwiftUI

let arrowPointUp = Image(systemName: "arrowtriangle.up.fill")

struct ContentView: View {
    @State private var tapLocation = CGPoint.zero

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Image("worldMap")
                    .resizable()
                
                arrowPointUp
                    .foregroundColor(.green)
                    .position(tapLocation)
                
                arrowPointUp
                    .foregroundColor(.blue)
                    .position(x: 670, y: 389)

                arrowPointUp
                    .foregroundColor(.blue)
                    .position(x: 1246, y: 467)
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
            .scaledToFit()
            .clipShape(Rectangle())
            .PinchToZoomAndPan(contentSize: CGSize(width: proxy.size.width, height: proxy.size.height), tapLocation: $tapLocation)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
