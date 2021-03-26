//
//  ApolloClient.swift
//  AroundTheGlobe
//
//  Created by Navati Jain on 2021-03-26.
//

import Foundation
import Apollo

class Apollo {
  static let shared = Apollo()
  let client: ApolloClient
  init() {
    //TODO: Remove forced unwrapping
    client = ApolloClient(url: URL(string: "https://countries.trevorblades.com")!)
  }
}
