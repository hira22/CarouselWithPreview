//
//  ContentView.swift
//  CarouselWithPreview
//
//  Created by hiraoka on 2021/12/27.
//

import SwiftUI

let colors: [Color] = [.black, .brown, .cyan, .gray, .green, .indigo, .mint, .orange,
                       .pink, .purple, .red, .teal, .white, .yellow,]

struct ContentView: View {
    @State var selection: Int = 0
    @State var isPresented: Bool = false

    var body: some View {
        VStack {
            TabView(selection: $selection) {
                ForEach(Array(zip(colors.indices, colors)), id: \.0) { item in
                    let item: (id: Int, color: Color) = item
                    item.color
                        .id(item.id)
                        .onTapGesture {
                            isPresented.toggle()
                        }
                }
            }
            .tabViewStyle(.page)

            ScrollView(.horizontal) {
                HStack(spacing: .zero) {
                    ForEach(Array(zip(colors.indices, colors)), id: \.0) { item in
                        let item: (id: Int, color: Color) = item
                        item.color
                            .frame(width: 50, height: 50)
                            .border(.blue, width: item.id == selection ? 3 : .zero)
                            .id(item.id)
                            .onTapGesture {
                                selection = item.id
                            }
                    }
                }
            }
        }
        .frame(height: 300)
        .sheet(isPresented: $isPresented) {
            ContentView()
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
