//
//  ErrorView.swift
//  AroundTheGlobe
//
//  Created by Navati Jain on 2021-03-26.
//

import SwiftUI

struct ErrorView: View {
    let error: CustomError
    let title: String
    let retryTitle: String = "Try again"
    let buttonHandler: (() -> ())
    
    var body: some View {
        NavigationView {
            VStack {
                Text(error.message)
                    .fontWeight(.bold)
                    .font(.body)
                    .padding()
                Button(action: { buttonHandler() }) {
                    Text(retryTitle)
                        .fontWeight(.bold)
                        .font(.body)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .padding()
                }
            }
            .navigationBarTitle(title, displayMode: .inline)
        }
    }
}

