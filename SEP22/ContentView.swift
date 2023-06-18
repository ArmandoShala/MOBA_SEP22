//
//  ContentView.swift
//  SEP22
//
//  Created by Armando Shala on 17.06.23.
//
//

import SwiftUI

struct ToggleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
                .padding(5)
                .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
                .font(.subheadline)
                .border(Color.black, width: 1)
    }
}

struct ContentView: View {
    @State private var shoes = [JsonRepresentation]()
    @State private var favorites = [JsonRepresentation]()
    @State private var searchText = ""

    private var searchResults: [JsonRepresentation] {
        if searchText.isEmpty {
            return shoes
        } else {
            return shoes.filter {
                $0.displayName.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        TabView {
            NavigationView {
                VStack {
                    Text("Guten Tag Armando Shala")
                            .font(.title)
                            .bold()
                            .padding()
                    HStack {
                        Button("<100") {
                            filterData(lowerPriceRange: "0", upperPriceRange: "100")
                        }
                        Button("100 - 120") {
                            filterData(lowerPriceRange: "100", upperPriceRange: "120")
                        }
                        Button("120 - 150") {
                            filterData(lowerPriceRange: "120", upperPriceRange: "150")
                        }
                        Button("150 - 170") {
                            filterData(lowerPriceRange: "150", upperPriceRange: "170")
                        }
                        Button(">170") {
                            filterData(lowerPriceRange: "170", upperPriceRange: "99999")
                        }
                        Button("Alle") {
                            loadData()
                        }
                    }
                            .buttonStyle(ToggleButtonStyle())
                    TextField("Search", text: $searchText)
                            .padding(.horizontal)
                    List {
                        ForEach(searchResults) {
                            shoe in
                            NavigationLink(destination: DetailPage(shoe: shoe)) {
                                HStack(alignment: .center) {
                                    Image(String(shoe.image1.split(separator: ".")[0]))
                                            .resizable()
                                            .frame(width: 100, height: 100)
                                            .scaledToFit()
                                            .border(Color.black, width: 1)
                                            .padding()
                                    Text(shoe.displayName)
                                            .font(.headline)
                                            .multilineTextAlignment(.leading)
                                    Spacer()
                                    Text("\(shoe.price) CHF")
                                            .font(.subheadline)
                                            .bold()
                                            .padding(.trailing, 10)
                                    Button(action: {
                                        addToFavorites(shoe: shoe)
                                    }) {
                                        if favorites.contains(where: { $0.productID == shoe.productID }) {
                                            Image(systemName: "star.circle.fill")
                                                    .foregroundColor(.red)
                                        } else {
                                            Image(systemName: "star.circle")
                                        }
                                    }
                                            .font(Font.system(.body).weight(.bold))
                                            .buttonStyle(PlainButtonStyle())
                                    Spacer()
                                }
                                        .border(Color.black, width: 1)
                                        .padding(.bottom, 10)
                            }
                        }
                    }
                            .listStyle(PlainListStyle())
                            .padding()
                            .onAppear(perform: loadData)
                }
            }
                    .onAppear(perform: loadData)
                    .refreshable(action: loadData)
                    .tabItem {
                        Label("Produkte", systemImage: "cart")
                    }
            NavigationView {
                VStack {
                    List {
                        ForEach(favorites) { shoe in
                            HStack(alignment: .center) {
                                Image(String(shoe.image1.split(separator: ".")[0]))
                                        .resizable()
                                        .frame(width: 100, height: 100)
                                        .scaledToFit()
                                        .border(Color.black, width: 1)
                                        .padding()
                                Text(shoe.displayName)
                                        .font(.headline)
                                        .multilineTextAlignment(.leading)
                                Spacer()
                                Text("\(shoe.price) CHF")
                                        .font(.subheadline)
                                        .bold()
                                        .padding(.trailing, 10)
                            }
                                    .border(Color.black, width: 1)
                                    .padding(.bottom, 10)
                        }

                    }
                            .listStyle(PlainListStyle())
                    Text("Total: \(favorites.reduce(0, { $0 + $1.price })) CHF")
                            .font(.title)
                            .padding()
                }
                        .padding()
            }
                    .tabItem {
                        Label("Wunschliste", systemImage: "heart")
                    }
        }
    }

    private func filterData(lowerPriceRange: String, upperPriceRange: String) {
        DispatchQueue.global().async {
            guard let file = Bundle.main.url(forResource: "sneakers", withExtension: "json") else {
                fatalError("Couldn't find json in main bundle.")
            }
            do {
                let jsonData = try Data(contentsOf: file)

                let decodedJson = try JSONDecoder().decode([JsonRepresentation].self, from: jsonData)
                DispatchQueue.main.async {
                    self.shoes = decodedJson.filter({
                        $0.price >= Int(Double(lowerPriceRange) ?? 0)
                                && $0.price < Int(Double(upperPriceRange) ?? 99999)
                    })
                }
            } catch {
                fatalError("Couldn't load file from main bundle:\n\(error)")
            }
        }
    }

    func loadData() {
        DispatchQueue.global().async {
            guard let file = Bundle.main.url(forResource: "sneakers", withExtension: "json") else {
                fatalError("Couldn't find json in main bundle.")
            }
            do {
                let jsonData = try Data(contentsOf: file)

                let decodedJson = try JSONDecoder().decode([JsonRepresentation].self, from: jsonData)
                DispatchQueue.main.async {
                    self.shoes = decodedJson
                }
            } catch {
                fatalError("Couldn't load file from main bundle:\n\(error)")
            }
        }
    }

    func addToFavorites(shoe: JsonRepresentation) {
        if favorites.contains(where: { $0.productID == shoe.productID }) {
            favorites.removeAll(where: { $0.productID == shoe.productID })
        } else {
            favorites.append(shoe)
        }
        if favorites.contains(where: { $0.productID == shoe.productID }) {
            Image(systemName: "star.circle.fill")
                    .foregroundColor(.red)
        } else {
            Image(systemName: "star.circle")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
