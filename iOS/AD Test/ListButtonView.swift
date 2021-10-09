//
//  ListButtonView.swift
//  AD Test
//
//  Created by Dava Tech Group, Inc.
//

import SwiftUI

struct ListButtonView: View {

    @ObservedObject var token: Token
    @ObservedObject var response: Response

    let api = API()

    var body: some View {
        Button("LIST DEVICES") {

            response.result = "Sending request.."

            // SECUTIRY WARNING
            // This is for testing purpose only!
            // You should never call this API in your app.
            // This should be called from your server instead.
            api.list(session: token.session) { result in
                response.result = result.description
            }

        }
        .font(.callout)
        .padding(10)
        .foregroundColor(.white)
        .background(Color.green)
        .cornerRadius(5.0)
    }
}
