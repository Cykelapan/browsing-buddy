//
//  Engine.swift
//  browsing-buddy
//
//  Created by Denis Ureke on 2025-03-10.
//

import UIKit
import WebKit



class WebViewController: UIViewController, WKNavigationDelegate, WKScriptMessageHandler {
    
    var webView: WKWebView!
    var actionQueue: [WebAction] = []
    var isProcessing = false
    var isNavigating = false
    var extractedText: String = ""
    var userSession: UserSession
    
    private var onQueueComplete: (() -> Void)?
    
    var onRequestUserInput: ((String, @escaping (String) -> Void) -> Void)?
    var onRequestShowMessage: ((String, String, Bool, @escaping () -> Void) -> Void)?
    
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
                    //print("Extracted text sparad: \(self.extractedText)") lämnar för debug
                }
                if messageBody.starts(with: "ExtractedList:") {
                    let extracted = messageBody.replacingOccurrences(of: "ExtractedList:", with: "")
                    self.extractedText = extracted
                    //print("Extracted text sparad: \(self.extractedText)")
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
            onQueueComplete?()
            onQueueComplete = nil
            return
        }
        
        let action = actionQueue.removeFirst()
        print("ELEMENTKEY", action.jsElementKey)
        print("WILLNAVIGATE", action.willNavigate)



        switch action.functionToCall.rawValue {
            
        case "INPUT_REQUEST":
            // Fungerar inte än
            onRequestUserInput?("Please enter search term") { userInput in
                self.processNextAction()
            }

        case "SHOW_MESSAGE":
            print("SHOW_MESSAGE")
            onRequestShowMessage?(action.informationTitle, action.descriptionMessage, action.accessCalendar ?? false) { // om ingen titel passeras in använda default
                self.processNextAction()
            }
        
        case "SHOW_EXTRACTED_MESSAGE":
            print("SHOW_EXTRACTED_MESSAGE")
            onRequestShowMessage?(action.informationTitle, self.extractedText, action.accessCalendar ?? false){
                self.extractedText = ""
                self.processNextAction()
            }
            
        case "NAVIGATE_WEB":
            print("Entered A")
            navigateToPage(urlString: action.websiteUrl)
            
        case "CLICK_ELEMENT_CLASS":
            print("CLICK_ELEMENT_CLASS")
            clickElementClass(withClass: action.jsElementKey, willNavigate: action.willNavigate)
            /*DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
             self.clickElementClass(withClass: action.parameter)
             }*/
        case "CLICK_ELEMENT_XPATH":
            print("CLICK_ELEMENT_XPATH")
            //clickElementByXPath(xpath: action.jsElementKey, willNavigate: action.willNavigate )
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { //bara test
             self.clickElementByXPath(xpath: action.jsElementKey, willNavigate: action.willNavigate )
             }
        case "EXTRACT_TEXT_XPATH":
            print("EXTRACT_TEXT_XPATH")
            extractTextByXPath(xpath: action.jsElementKey)
            
        case "INSERT_ELEMENT_XPATH":
            //print("INSERT_ELEMENT_XPATH")
            //fillElementByXPath(xpath: action.jsElementKey, willNavigate: action.willNavigate, valueType: action.extractFromUser)
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) { //bara test
             self.fillElementByXPath(xpath: action.jsElementKey, willNavigate: action.willNavigate, valueType: action.extractFromUser)
             }
            
        case "INSERT_ELEMENT_CLASS":
            print("INSERT_ELEMENT_CLASS")
            //fillElementByClass(className: action.jsElementKey, willNavigate: action.willNavigate, valueType: action.extractFromUser )
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) { //bara test
             self.fillElementByClass(className: action.jsElementKey, willNavigate: action.willNavigate, valueType: action.extractFromUser )
             }
            
        case "EXTRACT_LIST_BY_XPATH":
            print("EXTRACT_LIST_BY_XPATH")
            extractListItemsByXPath(xpath: action.jsElementKey)
            
        case "CLICK_ELEMENT_CLASS_HIGHLIGHT":
            //clickElementClassHighlight(withClass: action.jsElementKey, willNavigate: action.willNavigate)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
             self.clickElementClassHighlight(withClass: action.jsElementKey, willNavigate: action.willNavigate)
             }
            
        case "CLICK_ELEMENT_XPATH_HIGHLIGHT":
            clickElementByXPathHighlight(xpath: action.jsElementKey, willNavigate: action.willNavigate)
            
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
    
    func addActions(_ actions: [WebAction], onComplete: (() -> Void)? = nil) {
        print("action is called")
        actionQueue.append(contentsOf: actions)
        onQueueComplete = onComplete
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
    
    //klar
    private func clickElementClassHighlight(withClass className: String, willNavigate navigate: Bool) {
        isNavigating = navigate
        
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
                }, 2000);

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
    //klar
    private func extractListItemsByXPath(xpath: String) {
        let js = """
        function waitForElement(xpath) {
            var element = document.evaluate(xpath, document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue;
            if (element) {
                console.log('Element found using XPath, extracting list items...');
                var listItems = element.querySelectorAll('li');
                var texts = [];
                listItems.forEach(function(li) {
                    var text = li.innerText || li.textContent || '';
                    texts.push(text.trim());
                });
                var finalText = texts.join('\\n\\n');
                window.webkit.messageHandlers.callbackHandler.postMessage('ExtractedList:' + finalText);
            } else {
                console.log('Element not found, retrying...');
                setTimeout(function() { waitForElement(xpath); }, 500);
            }
        }
        waitForElement('\(xpath)');
        """

        webView.evaluateJavaScript(js) { _, error in
            if let error = error {
                print("JavaScript injection error: \(error.localizedDescription)")
            }
            self.processNextAction()
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

        webView.evaluateJavaScript(js) { _, error in
            if let error = error {
                print("JavaScript injection error: \(error.localizedDescription)")
            }
            self.processNextAction()
        }
    }

    
    //klar men svår att targetta med
    private func fillElementByXPath1(xpath: String, willNavigate navigate: Bool, valueType: ExtractFromUser) {
        let valueToInsert = valueType.getValue(session: userSession) //getValueForType(valueType: valueType)
        print("USERVALUE", valueToInsert )

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
    private func fillElementByClass(className: String, willNavigate navigate: Bool, valueType: ExtractFromUser) {
        let valueToInsert = valueType.getValue(session: userSession) //getValueForType(valueType: valueType)
        
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

        var spaceEvent = new KeyboardEvent('keydown', {
            bubbles: true,
            cancelable: true,
            key: ' ',   // Space key
            code: 'Space',
            view: window // Ensures event is dispatched properly
        });
                element.dispatchEvent(enterEvent);

                window.webkit.messageHandlers.callbackHandler.postMessage('Filled element with class: ' + className + ' and valueType: ' + value + ' and simulated Enter key.');
            } else {
                console.log('Element not found by class, retrying...');
                setTimeout(function() { waitForElementByClass(className, value); }, 500);
            }
        }
        waitForElementByClass('\(className)', '\(valueToInsert)');
        """

        /*let js = """
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
        """*/

        webView.evaluateJavaScript(js) { _, error in
            if let error = error {
                print("JavaScript injection error: \(error.localizedDescription)")
            }
            self.processNextAction()
        }
    }
    
    //inte klar
    private func fillElementByXPath(xpath: String, willNavigate navigate: Bool, valueType: ExtractFromUser) {
        let valueToInsert = valueType.getValue(session: userSession) // Extract value based on user session

        let js = """
        function waitForElementById(id, value) {
            var element = document.getElementById(id);
            
            if (element) {
                console.log('Element found using id:', id);

                
                if (element.offsetParent !== null && !element.disabled) {
                    console.log('Element is visible and enabled. Filling value...');

                    
                    element.click();
                    element.focus();

                    
                    function simulateTyping(element, text) {
                        for (let char of text) {
                            let event = new KeyboardEvent('keydown', { key: char, bubbles: true });
                            element.dispatchEvent(event);
                            element.value += char;
                            element.dispatchEvent(new InputEvent('input', { bubbles: true }));
                        }
                    }

                    
                    element.value = "";
                    element.dispatchEvent(new InputEvent('input', { bubbles: true }));

                    
                    setTimeout(() => {
                        simulateTyping(element, value);
                    }, 500);

                    
                    setTimeout(() => {
                        ['change', 'keydown', 'keyup', 'blur'].forEach(function(eventType) {
                            var event = new Event(eventType, { bubbles: true });
                            element.dispatchEvent(event);
                        });

                        
                        var enterEvent = new KeyboardEvent('keydown', {
                            bubbles: true,
                            cancelable: true,
                            key: 'Enter',
                            code: 'Enter',
                            keyCode: 13,
                            which: 13
                        });
        
                        element.dispatchEvent(enterEvent);

                        
                        window.webkit.messageHandlers.callbackHandler.postMessage('Filled element with id: ' + id + ' and valueType: ' + value + ' and simulated Enter key.');

                    }, 300); 

                } else {
                    console.log('Element found but not interactive (invisible or disabled), retrying...');
                    setTimeout(function() { waitForElementById(id, value); }, 500);
                }
            } else {
                console.log('Element not found by id:', id, 'retrying...');
                setTimeout(function() { waitForElementById(id, value); }, 500);
            }
        }
        waitForElementById('\(xpath)', '\(valueToInsert)');
        """

        
        /*let js = """
        function waitForElementById(id, value) {
            var element = document.getElementById(id);
            
            if (element) {
                console.log('Element found using id:', id);

                
                if (element.offsetParent !== null && !element.disabled) {
                    console.log('Element is visible and enabled. Filling value...');

                    
                    element.click();
                    element.focus();

                    
                    element.value = value;

                    
                    element.dispatchEvent(new InputEvent('input', { bubbles: true }));

                    
                    ['change', 'keydown', 'keyup', 'blur'].forEach(function(eventType) {
                        var event = new Event(eventType, { bubbles: true });
                        element.dispatchEvent(event);
                    });

                    // Simulate Enter keypress (optional, if needed)
                    var enterEvent = new KeyboardEvent('keydown', {
                        bubbles: true,
                        cancelable: true,
                        key: 'Enter',
                        code: 'Enter',
                        keyCode: 13,
                        which: 13
                    });
                    element.dispatchEvent(enterEvent);

                    window.webkit.messageHandlers.callbackHandler.postMessage('Filled element with id: ' + id + ' and valueType: ' + value + ' and simulated Enter key.');
                } else {
                    console.log('Element found but not interactive (invisible or disabled), retrying...');
                    setTimeout(function() { waitForElementById(id, value); }, 500);
                }
            } else {
                console.log('Element not found by id:', id, 'retrying...');
                setTimeout(function() { waitForElementById(id, value); }, 500);
            }
        }
        waitForElementById('\(xpath)', '\(valueToInsert)');
        """ */

        /*let js = """
        function waitForElementById(id, value) {
            var element = document.getElementById(id);
            if (element) {
                console.log('Element found using id, filling value...');
                element.focus();
                element.value = value;

                // Dispatch common events to mimic user input (for frameworks like React, Angular, etc.)
                ['input', 'change', 'keydown', 'keyup', 'blur'].forEach(function(eventType) {
                    var event = new Event(eventType, { bubbles: true });
                    element.dispatchEvent(event);
                });

                var enterEvent = new KeyboardEvent('keydown', {
                    bubbles: true,
                    cancelable: true,
                    key: 'Enter',
                    code: 'Enter',
                    keyCode: 13,
                    which: 13
                });
                element.dispatchEvent(enterEvent);

                // Notify Swift that the element was filled successfully and Enter was pressed
                window.webkit.messageHandlers.callbackHandler.postMessage('Filled element with id: ' + id + ' and valueType: ' + value + ' and simulated Enter key.');
            } else {
                console.log('Element not found by id, retrying...');
                setTimeout(function() { waitForElementById(id, value); }, 500);
            }
        }
        waitForElementById('\(xpath)', '\(valueToInsert)');
        """*/

        /*let js = """
        function waitForElementById(id, value) {
            var element = document.getElementById(id);
            if (element) {
                console.log('Element found using id, filling value...');
                element.focus();
                element.value = value;

                // Dispatch common events to mimic user input (for frameworks like React, Angular, etc.)
                ['input', 'change', 'keydown', 'keyup', 'blur'].forEach(function(eventType) {
                    var event = new Event(eventType, { bubbles: true });
                    element.dispatchEvent(event);
                });

                // Notify Swift that the element was filled successfully
                window.webkit.messageHandlers.callbackHandler.postMessage('Filled element with id: ' + id + ' and valueType: ' + value);
            } else {
                console.log('Element not found by id, retrying...');
                setTimeout(function() { waitForElementById(id, value); }, 500);
            }
        }
        waitForElementById('\(xpath)', '\(valueToInsert)');
        """*/

        // Inject the JavaScript into the web view and handle potential errors
        webView.evaluateJavaScript(js) { _, error in
            if let error = error {
                print("JavaScript injection error: \(error.localizedDescription)")
            }
            self.processNextAction()
        }
    }
    
    //helper för att välja ut rätt lösen, email, vad som egentligen
    private func getValueForType(valueType: String) -> String {
        switch valueType.lowercased() {
        case "email":
            return userSession.currentUser.email
        case "password":
            return userSession.currentUser.password
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
    
    //klar
    private func clickElementByXPathHighlight(xpath: String, willNavigate navigate: Bool) {
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
                    }, 3000);

                }, 1000);
                
            } else {
                console.log("Element not found, retrying...");
                setTimeout(function() { waitForElement(xpath); }, 1000); // Gör om gör rätt!
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
