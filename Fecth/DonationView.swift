import SwiftUI

struct DonationView: View {

    let mbwayNumber = "912000000"
    let iban = "PT50 0000 0000 0000 0000 0000 0"

    @State private var numberCopied = false
    @State private var ibanCopied = false

    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""

    var body: some View {

        ScrollView {

            VStack(spacing: 20) {

                Divider()

                Image(systemName: "heart.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.green)

                Text("Donativos")
                    .font(.title)
                    .bold()

                Text("Ajude a apoiar a nossa missão")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                // MARK: MB WAY

                GroupBox {

                    VStack(alignment: .leading, spacing: 15) {

                        Label("MB WAY", systemImage: "iphone")

                        Text(mbwayNumber)
                            .font(.title3)
                            .bold()

                        Button {
                            // 1. Copia o número
                            UIPasteboard.general.string = mbwayNumber
                            numberCopied = true

                            // abre aplicação MB WAY diretamente se instalada
                            openMBWayApp()

                        } label: {

                            Label(
                                numberCopied ? "Número Copiado ✓" : "Copiar Número",
                                systemImage: "doc.on.doc"
                            )
                            .frame(maxWidth: .infinity)

                        }
                        .buttonStyle(.borderedProminent)

                        Divider()

                        Text("""
                        Como doar por MB WAY:

                        1. Clique em "Copiar Número" (a app MB WAY tentará abrir).
                        2. Escolha "Enviar Dinheiro".
                        3. Cole o número copiado.
                        4. Valide o destinatario.
                        """)
                        .font(.caption)
                        .foregroundColor(.secondary)

                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                }

                // MARK: TRANSFERÊNCIA

                GroupBox {

                    VStack(alignment: .leading, spacing: 15) {

                        Label(
                            "Transferência Bancária",
                            systemImage: "building.columns"
                        )

                        Text(iban)
                            .font(.callout)
                            .textSelection(.enabled)

                        Button {

                            UIPasteboard.general.string = iban
                            ibanCopied = true

                            alertTitle = "IBAN Copiado"
                            alertMessage = """
                            O IBAN foi copiado para a área de transferência.

                            Pode utilizá-lo na aplicação do seu banco para efetuar a transferência.
                            """
                            showAlert = true

                        } label: {

                            Label(
                                ibanCopied ? "IBAN Copiado ✓" : "Copiar IBAN",
                                systemImage: "doc.on.doc"
                            )
                            .frame(maxWidth: .infinity)

                        }
                        .buttonStyle(.borderedProminent)

                        Divider()

                        Text("""
                        Utilize o IBAN acima para efetuar a transferência bancária.
                        """)
                        .font(.caption)
                        .foregroundColor(.secondary)

                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                }

                VStack(spacing: 5) {

                    Text("Obrigado pelo seu apoio")
                        .font(.headline)

                    Text("Toda contribuição ajuda a expandir esta missão.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.top)

            }
            .padding()

        }
        .alert(alertTitle, isPresented: $showAlert) {

            Button("OK") { }

        } message: {

            Text(alertMessage)

        }
    }
    
    // MARK: - Função Auxiliar
    
    func openMBWayApp() {
        guard let url = URL(string: "mbway://") else { return }
        
        UIApplication.shared.open(url, options: [:]) { success in
            DispatchQueue.main.async {
                if success {
                    // Se abriu a app, avisa que o número foi copiado com sucesso
                    self.alertTitle = "Número Copiado"
                    self.alertMessage = "Selecione 'enviar dinheiro' e cole o numero copiado"
                } else {
                    // Se aap mbway nao tiver instalada ...sugere o uso da app do próprio banco
                    self.alertTitle = "Número Copiado"
                    self.alertMessage = "O número foi copiado! Utilize a funcionalidade MB WAY dentro da aplicação do seu banco."
                }
                self.showAlert = true
            }
        }
    }
}

#Preview {
    DonationView()
}
