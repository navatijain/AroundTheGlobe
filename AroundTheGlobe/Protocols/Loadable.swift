//
//  Loadable.swift
//  AroundTheGlobe
//
//  Created by Navati Jain on 2021-03-26.
//

import Foundation

enum LoadingState<Value> {
    case notLoaded
    case loading
    case error(CustomError)
    case loaded(Value)
}

protocol Loadable: ObservableObject {
    associatedtype DataSource
    var state: LoadingState<DataSource> { get}
    func load()
}
