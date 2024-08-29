import SwiftUI

struct MainCardsScrollTabView<Content: View>: View {
    @Binding var selectedTab: Int
    let spacing: CGFloat
    let views: [Content]
    @State private var offset = CGFloat.zero

    var body: some View {
        VStack(spacing: spacing * 4) {
            GeometryReader { geo in
                let width = geo.size.width * 0.71
                let totalWidth = CGFloat(views.count) * (width + spacing) - spacing
                let leadingOffset = (geo.size.width - width) / 2
                let initialOffset: CGFloat = selectedTab == 0 ? geo.size.width / 23 : leadingOffset - CGFloat(selectedTab) * (width + spacing) + offset

                HStack(spacing: spacing) {
                    ForEach(0..<views.count, id: \.self) { idx in
                        views[idx]
                            .frame(width: width)
                            .padding(.vertical)
                    }
                }
                .frame(width: totalWidth, alignment: .leading)
                .offset(x: initialOffset)
                .animation(.easeOut, value: selectedTab)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            offset = value.translation.width
                        }
                        .onEnded { value in
                            withAnimation(.easeOut) {
                                offset = value.predictedEndTranslation.width
                                selectedTab -= Int((offset / width).rounded())
                                selectedTab = max(0, min(selectedTab, views.count - 1))
                                offset = 0
                            }
                        }
                )
            }

            HStack {
                ForEach(0..<views.count, id: \.self) { idx in
                    Circle().frame(width: 8)
                        .foregroundColor(idx == selectedTab ? .white : .gray)
                        .onTapGesture {
                            selectedTab = idx
                        }
                }
            }
            .padding(.top, UIScreen.main.bounds.width * 0.18)
        }
    }
}
