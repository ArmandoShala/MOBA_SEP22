//
// Created by Armando Shala on 18.06.23.
//

import SwiftUI

struct DetailPage: View {
    var shoe: JsonRepresentation
    var body: some View {
        VStack {
            Text(shoe.displayName)
                    .font(.title)
                    .padding()
            Image(String(shoe.image1.split(separator: ".")[0]))
                    .resizable()
                    .frame(width: 300, height: 300)
                    .scaledToFit()
                    .border(Color.black, width: 1)
                    .padding()
            Text("Preis: \(shoe.price) CHF")
                    .font(.title2)
                    .padding()
            Text("Farbe: \(shoe.color)")
                    .font(.title2)
                    .padding()
            Spacer()
        }
    }
}