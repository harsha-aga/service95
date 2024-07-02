//
//  ContentView.swift
//  Service95
//
//  Created by Harsha Agarwal on 24/06/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            Form {
                Section{
                    VStack {
                        Text("Welcome to")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .font(.title)
                            .fontDesign(.serif).fontWeight(.bold)
                        Text("SERVICE95").font(.largeTitle).fontWeight(.heavy)
                        Text("Service95").font(.subheadline).italic().bold()
                        + Text(" is the editorial platform founded by Dua Lipa. Through our website,")
                        + Text(" weekly newsletter").foregroundStyle(.blue).underline()
                        + Text(" , ")
                        + Text("podcast").foregroundStyle(.blue).underline()
                        + Text(" and ")
                        + Text("Book Club").foregroundStyle(.blue).underline()
                        + Text(", our mission is to celebrate the power of stories and recommendations from across the globe. ")
                        + Text("Subscribe").foregroundStyle(.blue).underline()
                        + Text(" now to feed your curiosity…")
                    }
                }
            }.navigationTitle("SERVICE95")
                .toolbar {
                    Button(action: {
                        print("ABC")
                    }, label: {
                        Image(systemName: "magnifyingglass").foregroundColor(.black)
                    })
                    Button {
                        print("jik")
                    } label: {
                        Image(systemName: "magnifyingglass").foregroundColor(.black)
                    }

            }
        }
    }
}

#Preview {
    ContentView()
}
