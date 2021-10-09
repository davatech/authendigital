//
//  ControlView.swift
//  AD Test
//
//  Created by Alexandre Fabri on 2021/08/30.
//

import SwiftUI

struct CoordinatorView: View {

    @State var username: String = ""
    @State var tokenSession: String = ""
    @State var tokenAuthentication: String = ""
    @State var isActivation = false
    @State var response: String = ""
    @StateObject var token = Token()

    var body: some View {

        VStack {

            Text("Authen Digital Test")
                .font(.headline)
                .padding(.top, 40)
                .foregroundColor(.purple)

            HStack {
                Text("USER:")
                    .font(.headline)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                TextField("username", text: $username)
                    .autocapitalization(.none)
                    .foregroundColor(.gray)
                Spacer()
            }
            .padding(.bottom, 25)
            .padding(.leading, 10)

            OpenButtonView(isActivation: $isActivation, username: $username) { result in
                response = result.description
                if let sessionToken = result.open.sessionToken {
                    tokenSession = sessionToken
                }
                if let authenticationToken = result.open.authenticationToken {
                    tokenAuthentication = authenticationToken
                }
            }
            .padding(.bottom, 35)
            .padding([.leading, .trailing], 10)

            HStack() {
                Spacer()
                ActivateButtonView()
                Spacer()
                InsertButtonView()
                Spacer()
                AuthenticateButtonView(authenticationToken: $tokenAuthentication, sessionToken: $tokenSession, response: $response)
                Spacer()
            }
            .padding(.bottom, 25)

            HStack {
                ListButtonView()
                Spacer()
            }
            .padding(.leading, 10)

            Spacer()

            TokenView(tokenSession: $tokenSession, tokenAuthentication: $tokenAuthentication)
                .padding(.leading, 10)
            ResponseView(text: $response)

        }
        .ignoresSafeArea()

    }

}

struct ControlView_Previews: PreviewProvider {
    static var previews: some View {
        CoordinatorView()
    }
}
