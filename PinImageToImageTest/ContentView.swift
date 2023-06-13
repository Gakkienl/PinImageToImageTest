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
    //@State private var height = 0.0
    //@State private var width = 0.0

    var body: some View {
        //GeometryReader { proxy in
            
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
//            .scaledToFit()
//            .clipShape(Rectangle())
            .PinchToZoomAndPan(contentSize: mapImage.size, tapLocation: $tapLocation)
//            }
        //}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct mapImagePinSmall: View {
    var body: some View {
        Button {
            print("Pin tapped!")
        } label: {
            arrowPointUp
                .frame(width: 44, height: 44, alignment: .center)
                .allowsHitTesting(true)
                .background(.gray)
                .zIndex(99)
        }
    }
}
