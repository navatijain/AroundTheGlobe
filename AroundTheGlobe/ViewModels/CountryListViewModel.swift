//
//  CountryListViewModel.swift
//  AroundTheGlobe
//
//  Created by Navati Jain on 2021-03-26.
//

import Foundation

class CountryListViewModel: Loadable {
    
    // MARK: - Properties
    
    private let service: CountryService
    @Published private(set) var state = LoadingState<[Country]>.notLoaded
    
    // MARK: - Init
    
    init(service: CountryService = CountryService()) {
        self.service = service
    }
    
    // MARK: - Methods

    func load() {
        state = .loading
        service.getCountries { [weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let countries):
                    if let countries = countries, countries.isEmpty == false {
                        self?.state = .loaded(countries)
                    } else {
                        self?.state = .error(.noData)
                    }
                case .failure(let error):
                    self?.state = .error(error)
                }
            }
        }
    }
}
