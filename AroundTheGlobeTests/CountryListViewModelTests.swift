//
//  CountryListViewModelTests.swift
//  AroundTheGlobeTests
//
//  Created by Navati Jain on 2021-03-26.
//

import XCTest
@testable import AroundTheGlobe

class CountryListViewModelTests: XCTestCase {

    class MockGetCountriesSuccessResponse: CountryService {
        override func getCountries(handler: @escaping CountryService.CountryListHandler) {
            handler(
                .success(
                    [
                        Country(name: "Samoa", code: "WS"),
                        Country(name: "Kosovo", code: "XK"),
                        Country(name: "Yemen", code: "YE"),
                        Country(name: "Mayotte", code: "YT"),
                        Country(name: "South Africa", code: "ZA")
                    ]
                )
            )
        }
    }
    
    class MockGetCountriesServerErrorResponse: CountryService {
        override func getCountries(handler: @escaping CountryService.CountryListHandler) {
            handler(.failure(.server))
        }
    }
    
    class MockGetCountriesNoDataResponse: CountryService {
        override func getCountries(handler: @escaping CountryService.CountryListHandler) {
            handler(.success([]))
        }
    }
    
    func testCountryServiceReturnsSuccessResponse() {
        let service = MockGetCountriesSuccessResponse()
        let viewModel = CountryListViewModel(service: service)
        let expectation = XCTestExpectation(description: "Expect state to change to .loaded")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            switch viewModel.state {
            case .loaded(let countries):
                expectation.fulfill()
                XCTAssertEqual(countries.count, 5)
                
            default:
                break
            }
        }
        
        viewModel.load()
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testCountryServiceReturnsServerErrorInResponse() {
        let service = MockGetCountriesServerErrorResponse()
        let viewModel = CountryListViewModel(service: service)
        let expectation = XCTestExpectation(description: "Expect state to change to .error")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            switch viewModel.state {
            case .error(let error):
                expectation.fulfill()
                XCTAssertEqual(error, .server, "error should be .server")
                
            default:
                break
            }
        }
        
        viewModel.load()
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testCountryServiceReturnsNoDataInResponse() {
        let service = MockGetCountriesNoDataResponse()
        let viewModel = CountryListViewModel(service: service)
        let expectation = XCTestExpectation(description: "Expect state to change to .error")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            switch viewModel.state {
            case .error(let error):
                expectation.fulfill()
                XCTAssertEqual(error, .noData, "error should be .noData")
                
            default:
                break
            }
        }
        
        viewModel.load()
        
        wait(for: [expectation], timeout: 5.0)
    }
}


