//
//  Token.swift
//  AD Test
//
//  Created by Dava Tech Group, Inc.
//

import Foundation

// SECUTIRY WARNING
// This is for testing purpose only!
// You should never store keys in your app.
// This should be done on your server instead.
class Token:ObservableObject {
    @Published var authentication = ""
    @Published var session = ""
}
