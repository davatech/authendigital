//
//  ControlView.swift
//  AD Test
//
//  Created by Dava Tech Group, Inc.
//

import SwiftUI

struct CoordinatorView: View {

    @State var username: String = ""
    @State var isActivation = false
    // Observables
    @StateObject var token = Token()
    @StateObject var response = Response()

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

            OpenButtonView(isActivation: $isActivation, username: $username, token: token, response: response)
            .padding(.bottom, 35)
            .padding([.leading, .trailing], 10)

            HStack() {
                Spacer()
                ActivateButtonView(token: token, response: response)
                Spacer()
                InsertButtonView(token: token, response: response)
                Spacer()
                AuthenticateButtonView(token: token, response: response)
                Spacer()
            }
            .padding(.bottom, 30)

            HStack {
                ListButtonView(token: token, response: response)
                Spacer()
                NewDeviceButton(token: token, response: response)
            }
            .padding([.leading, .trailing], 10)

            Spacer()

            TokenView(token: token)
                .padding(.leading, 10)
            ResponseView(response: response)

        }
        .ignoresSafeArea()

    }

}

struct ControlView_Previews: PreviewProvider {
    static var previews: some View {
        CoordinatorView()
    }
}
