import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = LoginViewModel()

    var body: some View {
        Group {
            if viewModel.isLoggedIn {
                PoliceStationMapView(viewModel: viewModel)
            } else {
                LoginView(viewModel: viewModel)
            }
        }
    }
}

#Preview {
    ContentView()
}
