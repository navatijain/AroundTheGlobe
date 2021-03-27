//
//  CountryDetailView.swift
//  AroundTheGlobe
//
//  Created by Navati Jain on 2021-03-26.
//

import SwiftUI

struct CountryDetailView: View {
    
    // MARK: - Properties
    
    @ObservedObject var viewModel: CountryDetailViewModel
    @State private var previewIndexLanguage = 0
    @State private var previewIndexState = 0
    
    private struct Constants {
        static let phone = "Phone"
        static let currency = "Currency"
        static let capital = "Capital"
        static let flag = "Flag"
        static let languages = "Languages"
        static let states = "States"
        static let title = "Country Detail"
    }
    
    // MARK: - Views

    var body: some View {
        switch viewModel.state {
        case .notLoaded:
            Color.clear.onAppear(perform: viewModel.load)
            
        case .loaded(let detail):
            Form {
                Section(header: Text(Constants.phone)) {
                    Text(detail.phone)
                }
                Section(header: Text(Constants.currency)) {
                    Text(detail.currency ?? "-")
                }
                Section(header: Text(Constants.capital)) {
                    Text(detail.capital ?? "-")
                }
                Section(header: Text(Constants.flag)) {
                    Text(detail.emoji)
                }
                if detail.languages.count > 0 {
                    Picker(selection: $previewIndexLanguage, label: Text(Constants.languages)) {
                        ForEach(0 ..< detail.languages.count) {
                            Text(detail.languages[$0].name ?? "")
                        }
                    }
                }
              
                if detail.states.count > 0 {
                    Picker(selection: $previewIndexState, label: Text(Constants.states)) {
                        ForEach(0 ..< detail.states.count) {
                            Text(detail.states[$0].name)
                        }
                    }
                }
            }
            .navigationBarTitle(Constants.title, displayMode: .inline)

        case .loading:
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: Color.purple))
                .scaleEffect(x: 2, y: 2, anchor: .center)
            
        case .error(let error):
            ErrorView(error: error, title: Constants.title, buttonHandler: viewModel.load)
        }
    }
}

struct CountryDetailView_Previews: PreviewProvider {
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
                                CountryDetail.State(name: "Maharashtra"),
                                CountryDetail.State(name: "Rajasthan"),
                                CountryDetail.State(name: "Gujarat")
                            ]
                    )
                )
            )
        }
    }
    
    class MockGetDetailsSuccessWithNilValuesInResponse: CountryService {
        
        override func getCountryDetail(
            for code: String,
            handler: @escaping CountryService.DetailsHandler
        ) {
            handler(
                .success(
                    CountryDetail(
                        phone: "91",
                        capital: nil,
                        currency: nil,
                        emoji: "🇮🇳",
                        languages:
                            [
                                CountryDetail.Language(name: "Hindi"),
                                CountryDetail.Language(name: "English")
                            ],
                        states:
                            [
                                CountryDetail.State(name: "Maharashtra"),
                                CountryDetail.State(name: "Rajasthan"),
                                CountryDetail.State(name: "Gujarat")
                            ]
                    )
                )
            )
        }
    }
    
    static var previews: some View {
        Group {
            CountryDetailView(
                viewModel: CountryDetailViewModel(
                    code: "IN",
                    service: MockGetDetailsSuccessResponse()
                )
            )
            CountryDetailView(
                viewModel: CountryDetailViewModel(
                    code: "IN",
                    service: MockGetDetailsSuccessWithNilValuesInResponse()
                )
            )
        }
    }
}
