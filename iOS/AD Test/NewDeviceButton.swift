//
//  OpenButtonView.swift
//  AD Test
//
//  Created by Dava Tech Group, Inc.
//

import SwiftUI
import Authen_Digital_iOS

struct NewDeviceButton: View {
    
    @ObservedObject var token: Token
    @ObservedObject var response: Response
    
    let api = API()
    
    var body: some View {
        HStack {
            Button("NEW DEVICE") {

                response.result = "Sending request.."

                // SECUTIRY WARNING
                // This is for testing purpose only!
                // You should never call this API in your app.
                // This should be called from your server instead.
                api.newDevice(session: token.session) { result in
                    if let authenticationToken = result.newDevice.authenticationToken, let sessionToken = result.newDevice.sessionToken {
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

        }
    }
}
