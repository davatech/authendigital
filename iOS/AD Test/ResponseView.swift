//
//  ResponseView.swift
//  AD Test
//
//  Created by Dava Tech Group, Inc.
//

import SwiftUI

struct ResponseView: View {

    @ObservedObject var response: Response

    var body: some View {
        ScrollView {
            Text(response.result)
                .font(.system(.callout, design: .monospaced))
                .foregroundColor(.green)
                .contextMenu(ContextMenu(menuItems: {
                    Button("Copy Response", action: {
                        UIPasteboard.general.string = response.result
                    })
                }))
        }
        .frame(width: UIScreen.main.bounds.size.width - 20, height: UIScreen.main.bounds.size.height / 3, alignment: .leading)
        .padding(10)
        .background(Color.black)
    }

}

struct ResponseView_Previews: PreviewProvider {
    static var previews: some View {
        ResponseView(response: Response())
            .previewLayout(.sizeThatFits)
    }
}
