import SwiftUI

struct ContribuicaoView: View {
    let phoneNumber = "912474404"
    @State private var copiado = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Apoie a nossa causa")
                .font(.title2)
                .fontWeight(.semibold)

            Button(action: {
                UIPasteboard.general.string = phoneNumber
                copiado = true
                // desaparece após 2 segundos
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    copiado = false
                }
            }) {
                HStack {
                    Text("Número: **\(phoneNumber)**")
                    Image(systemName: copiado ? "checkmark.circle.fill" : "doc.on.doc")
                        .foregroundColor(copiado ? .green : .gray)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
            }
            
            if copiado {
                Text("Número copiado! Agora basta colar no MB WAY.")
                    .font(.caption)
                    .foregroundColor(.green)
            }

            Button(action: openMBWayApp) {
                HStack {
                    Image(systemName: "arrow.right.circle.fill")
                    Text("Abrir App MB WAY")
                        .fontWeight(.bold)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.pink)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .padding(.horizontal)
        }
    }
    
    func openMBWayApp() {
        guard let url = URL(string: "mbway://") else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
