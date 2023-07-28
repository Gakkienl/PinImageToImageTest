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
        Zooming not always responsive. Tapping before zooming usually corrects this.
        Is it possible to include this in the zoom gesture?
        Also, zoomed in, not the whole image is viewable by scrolling!
 SOLUTION:
        Something to do with scale and offset, but can't figure it out ...
 */

import SwiftUI

struct ContentView2: View {
    @State private var mapImage = UIImage(named: "worldMap")!
    @State private var tapLocation = CGPoint.zero
    
    var body: some View {
        SwiftUIImageZoomViewer(image: mapImage)
    }
}

struct ContentView2_Previews: PreviewProvider {
    static var previews: some View {
        ContentView2()
    }
}
