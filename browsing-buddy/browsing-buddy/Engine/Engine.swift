//
//  Engine.swift
//  browsing-buddy
//
//  Created by Denis Ureke on 2025-03-10.
//

import UIKit
import WebKit

struct WebAction {
    let functionToCall: String
    let parameter: String
    let willNavigate: Bool // måste vara med ifall navigation sker vid en action

    init(functionToCall: String, parameter: String, willNavigate: Bool = false) {
        self.functionToCall = functionToCall
        self.parameter = parameter
        self.willNavigate = willNavigate
    }
}

class WebViewController: UIViewController, WKNavigationDelegate, WKScriptMessageHandler {
    
    var webView: WKWebView!
    var actionQueue: [WebAction] = []
    var isProcessing = false
    var isNavigating = false
    
    var onRequestUserInput: ((String, @escaping (String) -> Void) -> Void)?
    var onRequestShowMessage: ((String, @escaping () -> Void) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let contentController = WKUserContentController()
        contentController.add(self, name: "callbackHandler")
        
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        config.defaultWebpagePreferences.allowsContentJavaScript = true
        
        //webView = WKWebView(frame: self.view.bounds, configuration: config)
        webView = WKWebView(frame: .zero, configuration: config)
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)

        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        webView.navigationDelegate = self
    }
    
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "callbackHandler" {
            print("JavaScript says: \(message.body)")
            if !isNavigating {
                processNextAction()
            }
        }
    }
    
    func startProcessingQueue() {
        guard !isProcessing, !actionQueue.isEmpty else { return }
        isProcessing = true
        processNextAction()
    }
    
    private func processNextAction() {
        guard !actionQueue.isEmpty else {
            isProcessing = false
            return
        }
        
        let action = actionQueue.removeFirst()
        
        switch action.functionToCall {
        case "INPUT_REQUEST":
            // Fungerar inte än
            onRequestUserInput?("Please enter search term") { userInput in
                self.fillInputFieldName(usingName: "q", value: userInput)
                self.processNextAction()
            }

        case "SHOW_MESSAGE":
            onRequestShowMessage?(action.parameter) {
                self.processNextAction()
            }

        case "CLICK_BUTTON":
            clickElement(withId: action.parameter)
            processNextAction()
            
        case "A":
            print("Entered A")
            navigateToPage(urlString: action.parameter)
        case "B":
            print("Entered B")
            clickElement(withId: action.parameter)
        case "C":
            print("Entered C")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.fillInputField(withId: action.parameter, value: "Test Input")
            }
        case "D":
            print("Entered D")
            clickElementClass(withClass: action.parameter, willNavigate: action.willNavigate)
            /*DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
             self.clickElementClass(withClass: action.parameter)
             }*/
            
        case "E":
            print("Entered E")
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { //bara test
                self.fillInputFieldName(usingName: action.parameter, value: "Test")
            }
        case "F":
            print("Entered F")
            clickElementByAriaLabel(label: action.parameter)
            
        case "G":
            print("Entered G")
            clickElementByXPath(xpath: action.parameter, willNavigate: action.willNavigate )
            /*DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { //bara test
             self.clickElementByXPath(xpath: action.parameter, willNavigate: action.willNavigate)
             }*/
            
        default:
            print("Unknown action: \(action.functionToCall)")
            processNextAction()
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Page Loaded!!")
        if isNavigating {
            isNavigating = false
        }
        processNextAction()
    }
    
    func addActions(_ actions: [WebAction]) {
        actionQueue.append(contentsOf: actions)
        startProcessingQueue()
    }
    
    // Funktioner för som kallas
    
    private func navigateToPage(urlString: String) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    func testJavaScriptExecution() {
        let js = "alert('JavaScript is working!');"
        
        webView.evaluateJavaScript(js) { result, error in
            if let error = error {
                print("JavaScript execution failed: \(error.localizedDescription)")
            } else {
                print("JavaScript executed successfully.")
            }
        }
    }
    
    private func clickElement(withId id: String) {
        let js = """
        function waitForElement(id) {
            var element = document.getElementById(id);
            if (element) {
                element.click();
                window.webkit.messageHandlers.callbackHandler.postMessage('Clicked element with id: ' + id);
            } else {
                setTimeout(function() { waitForElement(id); }, 500); // Keep retrying until found
            }
        }
        waitForElement('\(id)');
        """
        
        webView.evaluateJavaScript(js) { _, error in
            if let error = error {
                print("JavaScript injection error: \(error.localizedDescription)")
                self.processNextAction() // Hantera om det inte fungerar
            }
            // bättre och logga i callbackhandler
        }
    }
    
    //klar
    private func clickElementClass(withClass className: String, willNavigate navigate: Bool) {
        isNavigating = navigate
        
        let js = """
        function waitForElement(className) {
            var elements = document.getElementsByClassName(className);
            if (elements.length > 0) {
                console.log("Element found, clicking...");
                elements[0].click(); // Click the first element
                window.webkit.messageHandlers.callbackHandler.postMessage('Clicked element with class: ' + className);
            } else {
                console.log("Element not found, retrying...");
                setTimeout(function() { waitForElement(className); }, 500); // Retry until found
            }
        }
        waitForElement('\(className)');
        """
        
        webView.evaluateJavaScript(js) { _, error in
            if let error = error {
                print("JavaScript Error: \(error.localizedDescription)")
                self.processNextAction()
            }
        }
    }
    
    private func clickElementClass2(withClass className: String) {
        let js = """
        function waitForElement(className, callback) {
            var elements = document.getElementsByClassName(className);
            if (elements.length > 0) {
                console.log("Element found, clicking...");
                elements[0].click();
            } else {
                console.log("Element not found, retrying...");
                setTimeout(function() { waitForElement(className); }, 500);
            }
        }
        waitForElement('\(className)');
        """
        
        webView.evaluateJavaScript(js) { _, error in
            if let error = error {
                print("JavaScript Error: \(error.localizedDescription)")
            } else {
                print("JavaScript executed successfully, element clicked.")
            }
            self.processNextAction()
        }
    }
    
    
    private func fillInputField(withId id: String, value: String) {
        let js = """
        function waitForInput(id, value, callback) {
            var element = document.getElementById(id);
            if (element) {
                element.value = value;
                element.dispatchEvent(new Event('input', { bubbles: true }));
                element.dispatchEvent(new Event('change', { bubbles: true }));
                callback();
            } else {
                setTimeout(function() { waitForInput(id, value, callback); }, 500);
            }
        }
        waitForInput('\(id)', '\(value)', function() {});
        """
        
        webView.evaluateJavaScript(js) { _, error in
            if let error = error {
                print("JavaScript Error: \(error.localizedDescription)")
            } else {
                print("JavaScript executed successfully, input field filled.")
            }
            self.processNextAction()
        }
    }
    
    private func fillInputFieldName(usingName name: String, value: String) {
        let js = """
        function waitForInput(name, value, callback) {
            var element = document.querySelector('input[name="' + name + '"]');
            if (element) {
                element.focus();
                element.value = value;
                element.dispatchEvent(new Event('input', { bubbles: true }));
                element.dispatchEvent(new Event('change', { bubbles: true }));
                
                // Simulate a real user typing by dispatching key events
                var event = new Event('keydown', { bubbles: true, cancelable: true });
                event.key = value.charAt(value.length - 1);
                element.dispatchEvent(event);
                
                element.blur();
                callback();
            } else {
                setTimeout(function() { waitForInput(name, value, callback); }, 500);
            }
        }
        waitForInput('\(name)', '\(value)', function() {});
        """
        
        webView.evaluateJavaScript(js) { _, error in
            if let error = error {
                print("JavaScript Error: \(error.localizedDescription)")
            } else {
                print("JavaScript executed successfully, input should be filled.")
            }
            self.processNextAction()
        }
    }
    
    private func clickElementByAriaLabel(label: String) {
        let js = """
        function waitForElement(label, callback) {
            var element = document.querySelector('[aria-label="' + label + '"]');
            if (element) {
                element.click();
                callback();
            } else {
                setTimeout(function() { waitForElement(label, callback); }, 500);
            }
        }
        waitForElement('\(label)', function() {});
        """
        
        webView.evaluateJavaScript(js) { _, error in
            if let error = error {
                print("JavaScript Error: \(error.localizedDescription)")
            } else {
                print("JavaScript executed successfully, button clicked.")
            }
            self.processNextAction()
        }
    }
    
    //klar
    private func clickElementByXPath(xpath: String, willNavigate navigate: Bool) {
        isNavigating = navigate
        
        let js = """
        function waitForElement(xpath) {
            var element = document.evaluate(xpath, document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue;
            if (element) {
                console.log('Element found using XPath, clicking...');
                element.click();
                window.webkit.messageHandlers.callbackHandler.postMessage('Clicked element with XPath: ' + xpath);
            } else {
                console.log('Element not found, retrying...');
                setTimeout(function() { waitForElement(xpath); }, 500); // Retry until found
            }
        }
        waitForElement('\(xpath)');
        """
        
        webView.evaluateJavaScript(js) { _, error in
            if let error = error {
                print("JavaScript injection error: \(error.localizedDescription)")
                self.processNextAction()
            }
        }
    }
    
}
