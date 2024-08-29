import SwiftUI

struct OurLocationView: View {
    @EnvironmentObject var viewModel : OurLocationViewModel
    var body: some View {
        ZStack {
            GoogleMapView()
        }
        .ignoresSafeArea(edges: .bottom)
    }
 
}

#Preview {
    OurLocationView()
        .background(.backgroundOne)
        .environmentObject(OurLocationViewModel())
}
