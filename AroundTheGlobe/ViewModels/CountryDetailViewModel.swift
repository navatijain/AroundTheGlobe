//
//  CountryDetailViewModel.swift
//  AroundTheGlobe
//
//  Created by Navati Jain on 2021-03-26.
//

import Foundation

class CountryDetailViewModel: Loadable {
    
    // MARK: - Properties
    
    private var service: CountryService
    @Published private(set) var state = LoadingState<CountryDetail>.notLoaded
    private let code: String
    
    // MARK: - Init
    
    init(code: String, service: CountryService = CountryService()) {
        self.code = code
        self.service = service
    }
    
    // MARK: - Methods

    func load() {
        state = .loading
        service.getCountryDetail(for: code.uppercased()) { [weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let detail):
                    self?.state = .loaded(detail)
                case .failure(let error):
                    self?.state = .error(error)
                }
            }
        }
    }
}
