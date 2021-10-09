//
//  ActivateButtonView.swift
//  AD Test
//
//  Created by Dava Tech Group, Inc.
//

import SwiftUI
import Authen_Digital_iOS

struct ActivateButtonView: View {

    @ObservedObject var token: Token
    @ObservedObject var response: Response
    let api = API()

    var body: some View {

        Button("ACTIVATE") {

            response.result = "Activating.."

            // Call Authenticate command from SDK
            AuthenDigital.activate(token.authentication) { result in
                
                // SECUTIRY WARNING
                // This is for testing purpose only!
                // You should never call this API in your app.
                // This should be called from your server instead.
                api.verify(token.session) { result in
                    response.result = result.description
                }

            }

        }
        .font(.callout)
        .padding(10)
        .foregroundColor(.white)
        .background(Color.purple)
        .cornerRadius(5.0)

    }

}
