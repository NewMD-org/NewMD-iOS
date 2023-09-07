//
//  ContentView.swift
//  NewMD
//
//  Created by Haco on 2023/9/5.
//

import SwiftUI
import WebKit

extension View {
    func resignKeyboardOnDragGesture() -> some View {
        return modifier(ResignKeyboardOnDragGesture())
    }
}

struct ResignKeyboardOnDragGesture: ViewModifier {
    func body(content: Content) -> some View {
        content
            .gesture(DragGesture().onChanged { _ in
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            })
    }
}

struct WebView: UIViewRepresentable {
    let urlString: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            uiView.load(request)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView

        init(_ parent: WebView) {
            self.parent = parent
        }

        // Implement WKNavigationDelegate methods if needed
    }
}

struct ContentView: View {
    var body: some View {
        WebView(urlString: "https://newmd.eu.org")
            .edgesIgnoringSafeArea(.all)
            .resignKeyboardOnDragGesture()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
