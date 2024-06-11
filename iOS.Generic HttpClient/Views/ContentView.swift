//
//  ContentView.swift
//  iOS.Generic HttpClient
//
//  Created by Alexy Nesterchuk on 08.06.2024.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = ContentViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.users, id:\.self) { user in
                Text(user.name)
            }
        }
        .padding()
        .onAppear {
            viewModel.fetch()
        }
    }
    
}

#Preview {
    ContentView()
}
