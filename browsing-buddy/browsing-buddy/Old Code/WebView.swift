//
//  WebView.swift
//  iOS4L
//
//  Created by Frida Granlund on 2025-03-08.
//

import Foundation
import WebKit
import UIKit
import SwiftUI

class ViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    @IBOutlet weak var txtFiled: UITextField!
    
    var webView: WKWebView!
    private let elementClickerHandler = "elementClickerHandler"
    private let connectWebToApp = "connectWebToApp"
    
    
    override func loadView() {
        print("Load 1")
        /*let webViewConfiguration = WKWebViewConfiguration()
        let contentController = WKUserContentController()

        contentController.add(self, name: elementClickerHandler)
        webViewConfiguration.userContentController = contentController
        webViewConfiguration.defaultWebpagePreferences.allowsContentJavaScript = true

        webView = WKWebView(frame: .zero, configuration: webViewConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view = webView*/
        print("load done")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let webViewConfiguration = WKWebViewConfiguration()
        let contentController = WKUserContentController()

        contentController.add(self, name: elementClickerHandler)
        webViewConfiguration.userContentController = contentController
        webViewConfiguration.defaultWebpagePreferences.allowsContentJavaScript = true
        webView = WKWebView(frame: .zero, configuration: webViewConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view = webView
        let url = URL(string: "https://www.jonkoping.se")!
        let request = URLRequest(url: url)
        webView.load(request)
        webView.allowsBackForwardNavigationGestures = true
                                      
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        monitorJS()
    }
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        //monitorJS()
    }
   
 
    func monitorJS() {
        
        let jsScript = """
        document.addEventListener("click", function(event) {
            let element = event.target;

            // Ignore clicks on the body, document, or other non-interactable elements
            if (!element || element.tagName.toLowerCase() === "html" || element.tagName.toLowerCase() === "body") return;

            let elementData = {
                tag: element.tagName.toLowerCase(),
                id: getValidId(element),
                classes: getValidClasses(element),
                path: getElementPath(element),
                xpath: getElementXPath(element),
                text: getTextContent(element),
                value: getInputValue(element)
            };

            
            try {
                window.webkit.messageHandlers.elementClickerHandler.postMessage(elementData);
            } catch (error) {
                console.error("Failed to Send Message to Swift:", error);
            }
        });   
        
        function getValidId(element) {
            if (element.id && !element.id.match(/^ember|react|vue|ng/)) {
                return `#${element.id}`;
            }
            return "No ID"; // Avoids unstable framework-generated IDs
        }

        
        function getValidClasses(element) {
            if (element.classList.length > 0) {
                return [...element.classList].filter(cls => !cls.match(/ember|react|vue|ng/)).join(", ");
            }
            return "No Classes";
        }        
        function getTextContent(element) {
            if (element.tagName.toLowerCase() === "input" || element.tagName.toLowerCase() === "textarea") {
                return element.placeholder || "No Placeholder";
            }
            return element.innerText.trim() || "No Text";
        }
        
        function getInputValue(element) {
            if (element.tagName.toLowerCase() === "input" || element.tagName.toLowerCase() === "textarea") {
                return element.value || "Empty";
            }
            return null;
        }

        function getElementPath(element) {
            if (element.id) return `#${element.id}`;
            let path = [];
            while (element.parentElement) {
                let selector = element.tagName.toLowerCase();
                if (element.className) {
                    selector += '.' + element.className.trim().replace(/\\s+/g, ".");
                }
                if (element.parentElement.children.length > 1) {
                    let index = Array.from(element.parentElement.children).indexOf(element);
                    selector += `:nth-child(${index + 1})`;
                }
                path.unshift(selector);
                element = element.parentElement;
            }
            return path.join(" > ");
        }        
        
        function getElementXPath(element) {
            if (element.id) return `//*[@id="${element.id}"]`;
            let path = [];
            while (element && element.nodeType === Node.ELEMENT_NODE) {
                let tag = element.nodeName.toLowerCase();
                let siblings = Array.from(element.parentNode ? element.parentNode.children : []);
                let index = siblings.filter(sibling => sibling.nodeName.toLowerCase() === tag).indexOf(element) + 1;
                path.unshift(`${tag}[${index}]`);
                element = element.parentNode;
            }
            return "/" + path.join("/");
        }
        """
       
        webView.evaluateJavaScript(jsScript)
       
    }
}
extension ViewController: WKScriptMessageHandler{
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {

                if message.name == elementClickerHandler {
                    if let elementData = message.body as? [String: Any] {
                        print(" Click Data:", elementData)
                    } else {
                        print("Invalid Data Format")
                    }
                } else {
                    print("Unexpected Message Name:", message.name)
                }
            }
}





struct WebViewWrapper: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> UIViewController {
        ViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
}
    

    
    

