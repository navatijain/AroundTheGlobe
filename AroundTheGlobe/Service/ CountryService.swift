//
//   CountryService.swift
//  AroundTheGlobe
//
//  Created by Navati Jain on 2021-03-26.
//

import Foundation
import Apollo

typealias Country = AllCountriesQuery.Data.Country
typealias CountryDetail = CountryDetailQuery.Data.Country

enum CustomError: Error {
    case invalidResponse
    case server
}

class CountryService {
    
    typealias HandlerType = (Result<[Country], CustomError>) -> ()
    typealias DetailsHandler = (Result<CountryDetail, CustomError>) -> ()
    
    func getCountries(handler: @escaping HandlerType) {
        let query = AllCountriesQuery()
        Apollo.shared.client.fetch(query: query) { result in
            switch result {
            case .success(let graphQLResult):
                if let countries = graphQLResult.data?.countries {
                    handler(.success(countries))
                } else {
                    handler(.failure(.invalidResponse))
                }
            case .failure(let error):
                handler(.failure(.server))
            }
        }
    }
    
    func getCountryDetail(
        for code: String,
        handler: @escaping DetailsHandler
    ) {
        let query = CountryDetailQuery(code: code)
        Apollo.shared.client.fetch(query: query, cachePolicy: .fetchIgnoringCacheCompletely) { result in
            switch result {
            case .success(let graphQLResult):
                if let country = graphQLResult.data?.country {
                    handler(.success(country))
                } else {
                    handler(.failure(.invalidResponse))
                }
            case .failure(let error):
                handler(.failure(.server))
            }
        }
    }
}


extension Country: Hashable {
    public static func == (lhs: AllCountriesQuery.Data.Country, rhs: AllCountriesQuery.Data.Country) -> Bool {
        lhs.__typename == rhs.__typename && lhs.code == rhs.code
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(code)
    }
}
