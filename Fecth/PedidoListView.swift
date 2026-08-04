import SwiftUI

struct PedidoListView: View {

    // Temporário, depois substituímos pelo retorno da API
    let pedidos = [
        PedidoMock(id: 1, produto: "Produto teste", status: "COMPLETO"),
        PedidoMock(id: 2, produto: "Outro produto", status: "PENDENTE")
    ]

    var body: some View {
        NavigationStack {

            List(pedidos) { pedido in

                NavigationLink {
                    PedidoDetailView(pedido: pedido)
                } label: {
                    VStack(alignment: .leading, spacing: 8) {

                        Text(pedido.produto)
                            .font(.headline)

                        Text("Pedido #\(pedido.id)")
                            .font(.subheadline)

                        Text(pedido.status)
                            .font(.caption)
                    }
                }
            }
            .navigationTitle("Meus Pedidos")
        }
    }
}


struct PedidoMock: Identifiable {

    let id: Int
    let produto: String
    let status: String
}
