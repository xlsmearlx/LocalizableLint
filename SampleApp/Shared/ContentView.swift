//
//  ContentView.swift
//  Shared
//
//  Created by Samuel Lagunes on 12/4/20.
//

import Foundation
import SwiftUI

struct ContentView: View {
    @State var dishes: [Dish] = [.init(name: "Barbacoa")]
    
    var body: some View {
        List(dishes) { dish in
            VStack {
                HStack {
                    Text(Bundle.main.localizedString(forKey: "DISH_NAME_LABEL", value: "", table: nil))
                    Text(dish.name).padding()
                }
                
                HStack {
                    Text("INGREDIENTS_LABEL")
                    Text(dish.name).padding()
                }
            }
            
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
