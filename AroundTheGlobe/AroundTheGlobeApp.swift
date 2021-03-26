//
//  AroundTheGlobeApp.swift
//  AroundTheGlobe
//
//  Created by Navati Jain on 2021-03-26.
//

import SwiftUI

@main
struct AroundTheGlobeApp: App {
    var body: some Scene {
        WindowGroup {
            CountryListView(viewModel: CountryListViewModel())
        }
    }
}
