//
//  ContentView.swift
//  AD Test
//
//  Created by Dava Tech Group, Inc.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        CoordinatorView()
            .padding()
            .ignoresSafeArea(.all)
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
