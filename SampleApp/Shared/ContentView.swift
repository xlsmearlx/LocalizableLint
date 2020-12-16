//
//  ContentView.swift
//  Shared
//
//  Created by Samuel Lagunes on 12/4/20.
//

import Foundation
import SwiftUI

struct ContentView: View {
    
    /*
     * DESCRIPTION_LABEL and NAME_LABEL will throw false positive
     * because they are not using localizedString syntax.
     * for this scenarios enable brute force.
     */
    @State var kvs: [LocalizedKeyView] = [.init(key: "DESCRIPTION_LABEL"),
                                          .init(key: "NAME_LABEL")]
    
    var body: some View {
        VStack {
            Text("AVAILABLE_LABEL")
            HStack {
                Spacer()
                Text(Bundle.main.localizedString(forKey: "KEY_LABEL", value: .none, table: .none))
                Spacer()
                Text(NSLocalizedString("VALUE_LABEL", comment: ""))
                Spacer()
            }
            List(kvs) { kv in
                HStack {
                    Spacer()
                    Text(kv.key)
                    Spacer()
                    Text(kv.value).padding()
                    Spacer()
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
