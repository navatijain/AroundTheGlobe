//
//  CountryDetailViewModelTests.swift
//  AroundTheGlobeTests
//
//  Created by Navati Jain on 2021-03-27.
//

import XCTest
@testable import AroundTheGlobe

class CountryDetailViewModelTests: XCTestCase {
    
    class MockGetDetailsSuccessResponse: CountryService {
        
        override func getCountryDetail(
            for code: String,
            handler: @escaping CountryService.DetailsHandler
        ) {
            handler(
                .success(
                    CountryDetail(
                        phone: "91",
                        capital: "New Delhi",
                        currency: "INR",
                        emoji: "🇮🇳",
                        languages:
                            [
                                CountryDetail.Language(name: "Hindi"),
                                CountryDetail.Language(name: "English")
                            ],
                        states:
                            [
                                CountryDetail.State(name: "So"),
                                CountryDetail.State(name: "Many"),
                                CountryDetail.State(name: "States"),
                            ]
                    )
                )
            )
        }
    }
    
    class MockGetDetailsNoDataResponse: CountryService {
        override func getCountryDetail(
            for code: String,
            handler: @escaping CountryService.DetailsHandler
        ) {
            handler(.success(nil))
        }
    }
    
    class MockGetCountriesServerErrorResponse: CountryService {
        override func getCountryDetail(
            for code: String,
            handler: @escaping CountryService.DetailsHandler
        ) {
            handler(.failure(.server))
        }
    }
    
    func testCountryDetailServiceReturnsSuccessResponse() {
        let service = MockGetDetailsSuccessResponse()
        let viewModel = CountryDetailViewModel(code: "IN", service: service)
        let expectation = XCTestExpectation(description: "Expect state to change to .loaded")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            switch viewModel.state {
            case .loaded:
                expectation.fulfill()
                
            default:
                break
            }
        }
        
        viewModel.load()
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testCountryDetailServiceReturnsServerErrorInResponse() {
        let service = MockGetCountriesServerErrorResponse()
        let viewModel = CountryDetailViewModel(code: "IN", service: service)
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
    
    func testCountryDetailServiceReturnsNoDataInResponse() {
        let service = MockGetDetailsNoDataResponse()
        let viewModel = CountryDetailViewModel(code: "IN", service: service)
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





