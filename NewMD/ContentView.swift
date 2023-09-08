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
            let webConfig = WKWebViewConfiguration()
            
            // Your existing configurations
            let preferences = WKPreferences()
            preferences.javaScriptCanOpenWindowsAutomatically = false
            webConfig.preferences = preferences
            
            let webView = WKWebView(frame: .zero, configuration: webConfig)
            webView.navigationDelegate = context.coordinator
            
            // Your existing configurations for zooming
            webView.scrollView.isScrollEnabled = true
            webView.scrollView.bouncesZoom = false
            webView.scrollView.minimumZoomScale = 1.0
            webView.scrollView.maximumZoomScale = 1.0

            // Add observers for keyboard frame change
            NotificationCenter.default.addObserver(context.coordinator, selector: #selector(context.coordinator.keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

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

    class Coordinator: NSObject, WKNavigationDelegate, UIScrollViewDelegate {
        var parent: WebView
        var webView: WKWebView?

        init(_ parent: WebView) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            // Your existing code
            let script = "var meta = document.createElement('meta'); meta.name = 'viewport'; meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no'; document.getElementsByTagName('head')[0].appendChild(meta);"
            webView.evaluateJavaScript(script, completionHandler: nil)
            self.webView = webView
        }

        @objc func keyboardWillChangeFrame(notification: NSNotification) {
            guard let userInfo = notification.userInfo else { return }
            guard let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
            
            if keyboardFrame.origin.y == UIScreen.main.bounds.height {
                // Keyboard is hidden
                // Reset any previous adjustments (if necessary)
                let resetJS = "window.scrollTo(0, 0);"
                webView?.evaluateJavaScript(resetJS, completionHandler: nil)
            } else {
                // Keyboard is shown
                // Execute JavaScript to scroll the web page to the active input element
                let js = "var focusedElement = document.activeElement; focusedElement.scrollIntoView({behavior: 'smooth'});"
                webView?.evaluateJavaScript(js, completionHandler: nil)
            }
        }

        
        deinit {
            // Remove the observers when the coordinator is deinitialized
            NotificationCenter.default.removeObserver(self)
        }
    }
}

struct ContentView: View {
    var body: some View {
        WebView(urlString: "https://newmd.eu.org")
            .resignKeyboardOnDragGesture()
            .navigationBarTitleDisplayMode(.inline)
            .animation(nil)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
