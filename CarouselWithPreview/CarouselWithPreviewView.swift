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
                item.color.id(item.id)
                    .onTapGesture {
                        isPresented.toggle()
                    }
            },
            carousel: { item in
                CellView(item: item, selection: $selection)
            }
        )
            .frame(height: 248)
            .sheet(isPresented: $isPresented) {
                SheetView(selection: $selection, items: items)
            }
    }

    struct SheetView: View {
        @Environment(\.presentationMode) private var presentationMode
        @Binding var selection: Int
        let items: [(id: Int, color: Color)]

        var body: some View {
            NavigationView {
                CarouselWithPreviewView(
                    selection: $selection,
                    items: items,
                    id: \.id,
                    preview: { item in
                        item.color.id(item.id)
                    },
                    carousel: { item in
                        CellView(item: item, selection: $selection)
                    }
                )
                    .frame(maxHeight: .infinity)
                    .navigationTitle("name")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                Image(systemName: "xmark")
                            }
                        }
                    }
            }
        }
    }

    struct CellView: View {
        let item: (id:Int, color: Color)
        @Binding var selection: Int

        var body: some View {
            item.color.id(item.id)
                .frame(width: 50, height: 50)
                .border(.blue, width: item.id == selection ? 3 : .zero)
                .onTapGesture {
                    selection = item.id
                }
        }
    }
}


struct CarouselWithPreviewView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CarouselWithPreviewWrappedView()
            CarouselWithPreviewWrappedView.SheetView(selection: .constant(1),
                                                     items: [
                                                        (id: 0, color: .black),
                                                        (id: 1, color: .brown),
                                                        (id: 2, color: .cyan)
                                                     ])
        }
    }
}
