//
//  ContentView.swift
//  AroundTheGlobe
//
//  Created by Navati Jain on 2021-03-26.
//

import SwiftUI

struct CountryListView: View {
    
    // MARK: - Properties
    
    @ObservedObject var viewModel: CountryListViewModel
    @State var searchText: String = ""
    
    private struct Constants {
        static let title = "Country List"
        static let searchPlaceholder = "Search country"
    }
    
    // MARK: - Views
    
    var body: some View {
        switch viewModel.state {
        case .notLoaded:
            Color.clear.onAppear(perform: viewModel.load)
            
        case .loaded(let countries):
            NavigationView {
                VStack {
                    SearchBar(text: $searchText, placeHolder: Constants.searchPlaceholder)
                        .padding(.top, 30)
                    List(
                        countries.filter{ searchText.isEmpty ? true : $0.name.contains(searchText) },
                        id: \.self
                    ) { country in
                        NavigationLink(
                            destination: CountryDetailView(
                                viewModel: CountryDetailViewModel(code: country.code)
                            )
                        ) {
                            CountryCell(countryModel: country)
                        }
                    }
                    .navigationBarTitle(Constants.title, displayMode: .inline)
                }
            }
            
        case .loading:
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: Color.purple))
                .scaleEffect(x: 2, y: 2, anchor: .center)
            
        case .error(let error):
            ErrorView(error: error, title: Constants.title, buttonHandler: viewModel.load)
        }
    }
}

struct CountryCell: View {
    let countryModel: Country
    
    var body: some View {
        Text(countryModel.name)
            .padding()
            .font(.title2)
    }
}

struct CountryListView_Previews: PreviewProvider {
    class MockGetCountriesSuccessResponse: CountryService {
        override func getCountries(handler: @escaping CountryService.CountryListHandler) {
            handler(
                .success(
                    [
                        Country(name: "Samoa", code: "WS"),
                        Country(name: "Kosovo", code: "XK"),
                        Country(name: "Yemen", code: "YE"),
                        Country(name: "Mayotte", code: "YT"),
                        Country(name: "South Africa", code: "ZA"),
                        Country(name: "India", code: "IN")
                    ]
                )
            )
        }
    }
    
    static var previews: some View {
        CountryListView(
            viewModel: CountryListViewModel(
                service: MockGetCountriesSuccessResponse()
            )
        )
    }
}

