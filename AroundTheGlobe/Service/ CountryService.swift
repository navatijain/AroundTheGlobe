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
    case server
    case noData
    
    var message: String {
        switch self {
        case .server:
            return "Error fetching response from Server!"
            
        case .noData:
            return "Sorry no data available to load!"
            
        }
    }
}

class CountryService {
    
    typealias CountryListHandler = (Result<[Country]?, CustomError>) -> ()
    typealias DetailsHandler = (Result<CountryDetail?, CustomError>) -> ()
    
    func getCountries(handler: @escaping CountryListHandler) {
        let query = AllCountriesQuery()
        Apollo.shared.client.fetch(query: query, cachePolicy: .fetchIgnoringCacheCompletely) { result in
            switch result {
            case .success(let graphQLResult):
                handler(.success(graphQLResult.data?.countries))
            case .failure:
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
                handler(.success(graphQLResult.data?.country))
            case .failure:
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
