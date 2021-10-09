//
//  OpenButtonView.swift
//  AD Test
//
//  Created by Dava Tech Group, Inc.
//

import SwiftUI
import Authen_Digital_iOS

struct OpenButtonView: View {

    @Binding var isActivation: Bool
    @Binding var username: String
    @ObservedObject var token: Token
    @ObservedObject var response: Response

    let api = API()

    var body: some View {

        HStack {
            Button("OPEN") {

                response.result = "Opening.."

                // SECUTIRY WARNING
                // This is for testing purpose only!
                // You should never call this API in your app.
                // This should be called from your server instead.
                api.open(isActivation: isActivation, username: username) { result in
                    if let authenticationToken = result.open.authenticationToken, let sessionToken = result.open.sessionToken {
                        token.authentication = authenticationToken
                        token.session = sessionToken
                    } else {
                        token.authentication = ""
                        token.session = ""
                    }
                    response.result = result.description
                }

            }
            .font(.callout)
            .padding(10)
            .foregroundColor(.white)
            .background(Color.green)
            .cornerRadius(5.0)
            
            Toggle("Check for activation", isOn: $isActivation)
                .font(.callout)
                .padding(.leading, 10)

            Spacer()
        }

    }

}
