//
//  StationView.swift
//  BDZDelays
//
//  Created by Alexander Ignatov on 21.04.23.
//

import SwiftUI

struct StationView: View {
    let vm: StationViewModel
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct StationView_Previews: PreviewProvider {
    static var previews: some View {
        StationView(vm: .init(name: "Горна Оряховица"))
    }
}
