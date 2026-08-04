import SwiftUI

struct MainView: View {

    @AppStorage("loggedInUserName") private var loggedInUserName = ""
    @Binding var isLoggedIn: Bool

    var body: some View {

        NavigationView {

            List {

                Section {

                    VStack(alignment: .leading, spacing: 6) {

                        Text("Bem-vindo!")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        Text(loggedInUserName)
                            .font(.title2)
                            .bold()

                        Text("O que deseja fazer?")
                            .foregroundColor(.secondary)

                    }
                    .padding(.vertical, 8)

                }

                Section("Pedidos") {

                    NavigationLink(destination: CreateOrderView()) {
                        Label("Novo Pedido", systemImage: "cart.badge.plus")
                    }

                    NavigationLink(destination: OrdersView()) {
                        Label("Meus Pedidos", systemImage: "cart")
                    }

                }

                Section("Catálogo") {

                    NavigationLink(destination: ItemListView()) {
                        Label("Itens", systemImage: "shippingbox")
                    }

                }

                Section("Outros") {

                    NavigationLink(destination: DonationView()) {
                        Label("Doações", systemImage: "heart")
                    }

                }

                Section {

                    Button(role: .destructive) {
                        logout()
                    } label: {
                        Label("Logout", systemImage: "rectangle.portrait.and.arrow.right")
                    }

                }

            }
            .navigationTitle("Sales API")

        }

    }

    private func logout() {
        loggedInUserName = ""
        isLoggedIn = false
    }
}
