//
//  TokenView.swift
//  AD Test
//
//  Created by Dava Tech Group, Inc.
//

import SwiftUI

// SECUTIRY WARNING
// This is for testing purpose only!
// You should never store keys in your app.
// This should be done on your server instead.
struct TokenView: View {

    @ObservedObject var token: Token

    var body: some View {
        VStack {
            HStack {
                Text("Session Token")
                    .font(.subheadline)
                    .fontWeight(.bold)
                Spacer()
            }

            HStack {
                TextField("token", text: $token.session)
                    .foregroundColor(.gray)
                    .font(.subheadline)
                    .contextMenu(ContextMenu(menuItems: {
                        Button("Copy Session Token", action: {
                            UIPasteboard.general.string = token.session
                        })
                    }))
                Spacer()
            }

            HStack {
                Text("Authentication Token")
                    .font(.subheadline)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                Spacer()
            }
            .padding(.top, 5)

            HStack {
                TextField("token", text: $token.authentication)
                    .foregroundColor(.gray)
                    .font(.subheadline)
                    .contextMenu(ContextMenu(menuItems: {
                        Button("Copy Authentication Token", action: {
                            UIPasteboard.general.string = token.authentication
                        })
                    }))
                Spacer()
            }
        }
    }
}

struct TokenView_Previews: PreviewProvider {
    static var previews: some View {
        TokenView(token: Token())
            .previewLayout(.sizeThatFits)
    }
}
