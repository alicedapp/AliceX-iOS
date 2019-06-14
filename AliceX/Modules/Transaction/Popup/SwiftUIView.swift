//
//  SwiftUIView.swift
//  AliceX
//
//  Created by lmcmz on 13/6/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import SwiftUI

struct SwiftUIView : View {
    var body: some View {
        Group {
            VStack {
                Text(/*@START_MENU_TOKEN@*/"Placeholder"/*@END_MENU_TOKEN@*/)
                Text("World!")
            }
        }
    }
}

#if DEBUG
struct SwiftUIView_Previews : PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
#endif
