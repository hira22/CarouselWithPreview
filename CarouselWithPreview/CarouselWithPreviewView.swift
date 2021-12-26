//
//  CarouselWithPreviewView.swift
//  CarouselWithPreview
//
//  Created by hiraoka on 2021/12/27.
//

import SwiftUI

struct CarouselWithPreviewView<Data, ID, Preview, Carousel>: View where Data: RandomAccessCollection, ID: Hashable, Preview: View, Carousel: View {
    @Binding var selection: ID

    let items: Data
    let id: KeyPath<Data.Element, ID>
    @ViewBuilder let preview: (Data.Element) -> Preview
    @ViewBuilder let carousel: (Data.Element) -> Carousel

    var body: some View {
        VStack {
            TabView(selection: $selection) {
                ForEach(items, id: id, content: preview)
            }
            .tabViewStyle(.page)

            ScrollViewReader { proxy in
                ScrollView(.horizontal) {
                    HStack(spacing: .zero) {
                        ForEach(items, id: id, content: carousel)
                    }
                }
                .onChange(of: selection) { newValue in
                    withAnimation {
                        proxy.scrollTo(newValue, anchor: .center)
                    }
                }
            }
        }
    }
}

struct CarouselWithPreviewWrappedView: View {
    @State var selection: Int = 0
    @State var isPresented: Bool = false
    let items: [(id: Int, color: Color)] = Array(zip(colors.indices, colors))

    var body: some View {
        CarouselWithPreviewView(
            selection: $selection,
            items: items,
            id: \.id,
            preview: { item in
                item.color
                    .id(item.id)
                    .onTapGesture {
                        isPresented.toggle()
                    }
            },
            carousel: { item in
                item.color
                    .frame(width: 50, height: 50)
                    .border(.blue, width: item.id == selection ? 3 : .zero)
                    .id(item.id)
                    .onTapGesture {
                        selection = item.id
                    }
            }
        )
            .frame(height: 300)
            .sheet(isPresented: $isPresented) {
                NavigationView {
                    CarouselWithPreviewSheetView(selection: $selection, items: items)
                        .frame(maxHeight: .infinity)
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button("close") {
                                    isPresented.toggle()
                                }
                            }
                        }
                        .padding(.bottom)
                }
            }
    }

    struct CarouselWithPreviewSheetView: View {
        @Binding var selection: Int
        let items: [(id: Int, color: Color)]

        var body: some View {
            CarouselWithPreviewView(
                selection: $selection,
                items: items,
                id: \.id,
                preview: { item in
                    item.color.id(item.id)
                },
                carousel: { item in
                    item.color
                        .frame(width: 50, height: 50)
                        .border(.blue, width: item.id == selection ? 3 : .zero)
                        .id(item.id)
                        .onTapGesture {
                            selection = item.id
                        }
                }
            )
        }
    }
}


struct CarouselWithPreviewView_Previews: PreviewProvider {
    static var previews: some View {
        CarouselWithPreviewWrappedView()
    }
}
