import SwiftUI

struct OrdersView: View {

    var body: some View {

        NavigationStack {

            List {

                Section("Pedidos") {

                    NavigationLink {
                        OrderListView()
                    } label: {
                        Label("Meus Pedidos", systemImage: "shippingbox")
                    }

                    NavigationLink {
                        CreateOrderView()
                    } label: {
                        Label("Novo Pedido", systemImage: "plus.circle")
                    }
                }

                Section("Informações") {

                    Label("Acompanhe seus pedidos", systemImage: "clock")

                    Label("Consulte o status", systemImage: "checkmark.circle")
                }
            }
            .navigationTitle("Pedidos")
        }
    }
}

#Preview {
    OrdersView()
}

