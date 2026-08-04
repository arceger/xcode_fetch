import SwiftUI

struct PedidoDetailView: View {

    let pedido: PedidoMock

    var body: some View {

        VStack(spacing: 20) {

            Text("Pedido #\(pedido.id)")
                .font(.largeTitle)

            Text(pedido.produto)
                .font(.title2)

            Text("Status: \(pedido.status)")
                .font(.headline)

        }
        .padding()
        .navigationTitle("Detalhes")
    }
}

