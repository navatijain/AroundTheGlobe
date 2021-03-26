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
    }
    
    // MARK: - Views

    var body: some View {
        switch viewModel.state {
        case .notLoaded:
            Color.clear.onAppear(perform: viewModel.load)
            
        case .loaded(let countries):
            NavigationView {
                VStack {
                    List(countries, id: \.self) { country in
                        Text(country.name)
                    }
                    .listRowBackground(Color.red)
                    .navigationBarTitle(Constants.title, displayMode: .inline)
                }
            }
            
        case .loading:
            ProgressView()
                .accentColor(Color.blue)
                .scaleEffect(x: 2, y: 2, anchor: .center)
            
        case .error(let error):
            //error
            Text("error")
        }
    }
}

struct CountryCell: View {
    let countryModel: Country
    
    var body: some View {
        Text(countryModel.name)
            .padding()
            .font(.title2)
            .foregroundColor(.purple)
    }
}

struct CountryListView_Previews: PreviewProvider {
    static var previews: some View {
        CountryListView(viewModel: CountryListViewModel())
    }
}

