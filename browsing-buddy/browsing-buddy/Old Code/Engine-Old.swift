//
//  Engine-Old.swift
//  browsing-buddy
//
//  Created by Denis Ureke on 2025-03-09.
//

/*
import UIKit
import WebKit

struct WebAction {
    let functionToCall: String
    let parameter: String
}

class WebViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    var actionQueue: [WebAction] = []
    var isProcessing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences.allowsContentJavaScript = true
        webView = WKWebView(frame: self.view.bounds, configuration: config)
        webView.navigationDelegate = self
        view.addSubview(webView)
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
            //clickElementClass(withClass: action.parameter)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.clickElementClass(withClass: action.parameter)
            }
            
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
            //clickElementByXPath(xpath: action.parameter)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { //bara test
                self.clickElementByXPath(xpath: action.parameter)
            }
            
        default:
            print("Unknown action: \(action.functionToCall)")
            processNextAction()
        }
    }
    
    private func navigateToPage(urlString: String) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    private func clickElement(withId id: String) {
        let js = """
        function waitForElement(id, callback) {
            var element = document.getElementById(id);
            if (element) {
                callback(element);
            } else {
                setTimeout(function() { waitForElement(id, callback); }, 500);
            }
        }
        waitForElement('\(id)', function(element) { element.click(); });
        """
        
        webView.evaluateJavaScript(js) { _, error in
            if let error = error {
                print("Error clicking element: \(error)")
            }
            self.processNextAction()
        }
    }
    
    private func clickElementClass(withClass className: String) {
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
    
    /*private func clickElementClass(withClass className: String) {
        let js = """
        function waitForElement(className) {
            var elements = document.getElementsByClassName(className);
            if (elements.length > 0) {
                console.log("Element found, adding overlay...");

                var element = elements[0];

                var rect = element.getBoundingClientRect();

                var overlay = document.createElement("div");
                overlay.style.position = "absolute";
                overlay.style.top = rect.top + window.scrollY + "px";
                overlay.style.left = rect.left + window.scrollX + "px";
                overlay.style.width = rect.width + "px";
                overlay.style.height = rect.height + "px";
                overlay.style.backgroundColor = "rgba(0, 0, 255, 0.3)"; // Blue semi-transparent
                overlay.style.zIndex = "5000";
                overlay.style.pointerEvents = "none";

                document.body.appendChild(overlay);

                setTimeout(function() {
                    overlay.remove();
                    element.click();
                    console.log("Element clicked!");
                }, 500); // Delay to make the highlight visible
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
                print("JavaScript executed successfully, overlay added and element clicked.")
            }
            self.processNextAction()
        }
    }*/

    
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

    private func clickElementByXPath(xpath: String) {
        let js = """
        function waitForElement(xpath, callback) {
            var element = document.evaluate(xpath, document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue;
            if (element) {
                element.click();
                callback();
            } else {
                setTimeout(function() { waitForElement(xpath, callback); }, 500);
            }
        }
        waitForElement('\(xpath)', function() {});
        """

        webView.evaluateJavaScript(js) { _, error in
            if let error = error {
                print("JavaScript Error: \(error.localizedDescription)")
            } else {
                print("JavaScript executed successfully, element clicked using XPath.")
            }
            self.processNextAction()
        }
    }

    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Page Loaded!!")
        processNextAction()
    }
    
    func addActions(_ actions: [WebAction]) {
        actionQueue.append(contentsOf: actions)
        startProcessingQueue()
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
}
*/
