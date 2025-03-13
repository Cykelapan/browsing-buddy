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
    let extractFromUser: String?

    init(functionToCall: String, parameter: String, willNavigate: Bool = false, extractFromUser: String? = nil) {
        self.functionToCall = functionToCall
        self.parameter = parameter
        self.willNavigate = willNavigate
        self.extractFromUser = extractFromUser
    }
}

class WebViewController: UIViewController, WKNavigationDelegate, WKScriptMessageHandler {
    
    var webView: WKWebView!
    var actionQueue: [WebAction] = []
    var isProcessing = false
    var isNavigating = false
    var extractedText: String = ""
    var userSession: UserSession
    
    var onRequestUserInput: ((String, @escaping (String) -> Void) -> Void)?
    var onRequestShowMessage: ((String, @escaping () -> Void) -> Void)?
    
    init(userSession: UserSession) {
        self.userSession = userSession
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented") // psyko UIkit
    }
    
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
            
            //Ta emot extracted
            if let messageBody = message.body as? String {
                if messageBody.starts(with: "ExtractedText:") {
                    let extracted = messageBody.replacingOccurrences(of: "ExtractedText:", with: "")
                    self.extractedText = extracted
                    print("Extracted text sparad: \(self.extractedText)")
                }
            }
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
                self.processNextAction()
            }

        case "SHOW_MESSAGE":
            onRequestShowMessage?(action.parameter) {
                self.processNextAction()
            }
        
        case "SHOW_EXTRACTED_MESSAGE":
            onRequestShowMessage?(self.extractedText){
                self.extractedText = ""
                self.processNextAction()
            }
            
        case "A":
            print("Entered A")
            navigateToPage(urlString: action.parameter)
        case "D":
            print("Entered D")
            clickElementClass(withClass: action.parameter, willNavigate: action.willNavigate)
            /*DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
             self.clickElementClass(withClass: action.parameter)
             }*/
        case "G":
            print("Entered G")
            clickElementByXPath(xpath: action.parameter, willNavigate: action.willNavigate )
            /*DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { //bara test
             self.clickElementByXPath(xpath: action.parameter, willNavigate: action.willNavigate)
             }*/
        case "Extract_Message":
            extractTextByXPath(xpath: action.parameter)
            
        case "Insert_Element":
            fillElementByXPath(xpath: action.parameter, willNavigate: action.willNavigate, valueType: action.extractFromUser ?? "")
            
        case "Insert_Element_Class":
            fillElementByClass(className: action.parameter, willNavigate: action.willNavigate, valueType: action.extractFromUser ?? "")
            
            
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
    
    //klar
    private func clickElementClass(withClass className: String, willNavigate navigate: Bool) {
        isNavigating = navigate
        
        /*let js = """
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
        """*/
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
                overlay.style.width = "100px";
                overlay.style.height = "100px";
                overlay.style.backgroundColor = "rgba(0, 0, 255, 0.3)";
                overlay.style.zIndex = "5000";
                overlay.style.pointerEvents = "none";
                overlay.style.borderRadius = "50%";

                document.body.appendChild(overlay);

                setTimeout(function() {
                    overlay.remove();
                    element.click();
                    console.log("Element clicked!");

                    window.webkit.messageHandlers.callbackHandler.postMessage('Clicked element with class: ' + className);
                }, 1000);

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
                self.processNextAction()
            }
        }
    }
    
    //Klar
    private func extractTextByXPath(xpath: String) {
        let js = """
        function waitForElement(xpath) {
            var element = document.evaluate(xpath, document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue;
            if (element) {
                console.log('Element found using XPath, extracting text...');
                var text = element.innerText || element.textContent || '';
                window.webkit.messageHandlers.callbackHandler.postMessage('ExtractedText:' + text);
            } else {
                console.log('Element not found, retrying...');
                setTimeout(function() { waitForElement(xpath); }, 500);
            }
        }
        waitForElement('\(xpath)');
        """
        
        webView.evaluateJavaScript(js, completionHandler: nil)
    }
    
    //klar men svår att targetta med
    private func fillElementByXPath(xpath: String, willNavigate navigate: Bool, valueType: String) {
        let valueToInsert = getValueForType(valueType: valueType)

        let js = """
        function waitForElement(xpath, value) {
            var element = document.evaluate(xpath, document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue;
            if (element) {
                console.log('Element found using XPath, filling value...');
                element.focus();
                element.value = value;
                element.dispatchEvent(new Event('input', { bubbles: true }));
                window.webkit.messageHandlers.callbackHandler.postMessage('Filled element with XPath: ' + xpath + ' and valueType: ' + value);
            } else {
                console.log('Element not found, retrying...');
                setTimeout(function() { waitForElement(xpath, value); }, 500);
            }
        }
        waitForElement('\(xpath)', '\(valueToInsert)');
        """

        webView.evaluateJavaScript(js) { _, error in
            if let error = error {
                print("JavaScript injection error: \(error.localizedDescription)")
            }
            self.processNextAction()
        }
    }
    
    //klar Fungerar bättre med class om det e textfields
    private func fillElementByClass(className: String, willNavigate navigate: Bool, valueType: String) {
        let valueToInsert = getValueForType(valueType: valueType)

        let js = """
        function waitForElementByClass(className, value) {
            var elements = document.getElementsByClassName(className);
            if (elements.length > 0) {
                var element = elements[0];
                console.log('Element found using class, filling value...');
                element.focus();
                element.value = value;

                ['input', 'change', 'keydown', 'keyup', 'blur'].forEach(function(eventType) {
                    var event = new Event(eventType, { bubbles: true });
                    element.dispatchEvent(event);
                });

                window.webkit.messageHandlers.callbackHandler.postMessage('Filled element with class: ' + className + ' and valueType: ' + value);
            } else {
                console.log('Element not found by class, retrying...');
                setTimeout(function() { waitForElementByClass(className, value); }, 500);
            }
        }
        waitForElementByClass('\(className)', '\(valueToInsert)');
        """

        webView.evaluateJavaScript(js) { _, error in
            if let error = error {
                print("JavaScript injection error: \(error.localizedDescription)")
            }
            self.processNextAction()
        }
    }
    
    private func getValueForType(valueType: String) -> String {
        switch valueType.lowercased() {
        case "email":
            return userSession.currentUser?.email ?? ""
        case "password":
            return userSession.currentUser?.password ?? ""
        //Får lägga till fler
        default:
            print("Unknown valueType: \(valueType)")
            return valueType
        }
    }

    
    //klar
    private func clickElementByXPath(xpath: String, willNavigate navigate: Bool) {
        isNavigating = navigate
        
        let js = """
        function waitForElement(xpath) {
            var result = document.evaluate(xpath, document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
            var element = result.singleNodeValue;

            if (element) {
                console.log("Element found via XPath, scrolling and adding overlay...");

                //idiot vänta på den
                element.scrollIntoView({ behavior: 'smooth', block: 'center' });

                // Jupp!! Där satt den! Tack Indiska Youtube!
                setTimeout(function() {

                    var rect = element.getBoundingClientRect();

                    var overlay = document.createElement("div");
                    overlay.style.position = "absolute";
                    overlay.style.top = (rect.top + window.scrollY + (rect.height / 2) - 50) + "px";
                    overlay.style.left = (rect.left + window.scrollX + (rect.width / 2) - 50) + "px";
                    overlay.style.width = "100px";
                    overlay.style.height = "100px";
                    overlay.style.backgroundColor = "rgba(0, 0, 255, 0.3)";
                    overlay.style.zIndex = "5000";
                    overlay.style.pointerEvents = "none";
                    overlay.style.borderRadius = "50%"; // Circle shape

                    document.body.appendChild(overlay);

                    setTimeout(function() {
                        overlay.remove();
                        element.click();
                        console.log("Element clicked!");

                        window.webkit.messageHandlers.callbackHandler.postMessage('Clicked element via XPath: ' + xpath);
                    }, 1000);

                }, 500);
                
            } else {
                console.log("Element not found, retrying...");
                setTimeout(function() { waitForElement(xpath); }, 500); // Gör om gör rätt!
            }
        }
        waitForElement('\(xpath)');
        """
        
        /*let js = """
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
        """*/
        
        webView.evaluateJavaScript(js) { _, error in
            if let error = error {
                print("JavaScript injection error: \(error.localizedDescription)")
                self.processNextAction()
            }
        }
    }
    
}
