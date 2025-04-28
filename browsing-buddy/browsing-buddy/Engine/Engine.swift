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
    var isWaitingForUserInput = false
    
    private var onQueueComplete: (() -> Void)?
    private var lastPageURL: URL?
    
    var onRequestUserInput: ((String, String, @escaping (String) -> Void) -> Void)?
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
        // För errors
        contentController.add(self, name: "errorHandler")
        
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
        switch message.name {
        
        case "callbackHandler":
            print("JavaScript says (callbackHandler): \(message.body)")

            if let messageBody = message.body as? String {
                if messageBody.starts(with: "ExtractedText:") {
                    let extracted = messageBody.replacingOccurrences(of: "ExtractedText:", with: "")
                    self.extractedText = extracted
                    userSession.extractedText = extracted
                    //print("Extracted text saved: \(self.extractedText)")
                } else if messageBody.starts(with: "ExtractedList:") {
                    let extracted = messageBody.replacingOccurrences(of: "ExtractedList:", with: "")
                    self.extractedText = extracted
                    // print("Extracted list saved: \(self.extractedText)")
                } else {
                    print("Unrecognized callbackHandler message: \(messageBody)")
                }
            }

            if !isNavigating && !isWaitingForUserInput {
                processNextAction()
            }

        // Felmedellanden
        case "errorHandler":
            if let errorMessage = message.body as? String {
                print("JavaScript errorHandlöer says: \(errorMessage)")
                // Optionally: Notify user, log error, skip action, etc.
            }
            
            if !isNavigating && !isWaitingForUserInput {
                processNextAction()
            }

        default:
            print("No header added: \(message.name)")
        }
    }

    
    func startProcessingQueue() {
        guard !isProcessing, !actionQueue.isEmpty else { return }
        isProcessing = true
        print("action is called")
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
        print("FUNCTION TO CALL", action.functionToCall)


        switch action.functionToCall.rawValue {
            
        case "INPUT_REQUEST":
            print("Entered INPUT_REQUEST")
            let titleText = action.informationTitle.isEmpty ? "Information" : action.informationTitle
            let promptText = action.descriptionMessage.isEmpty ? "" : action.descriptionMessage
            requestUserInput(title: titleText, prompt: promptText)

        case "SHOW_MESSAGE":
            print("Entered SHOW_MESSAGE")
            onRequestShowMessage?(action.informationTitle, action.descriptionMessage, action.accessCalendar) { // om ingen titel passeras in använda default
                self.processNextAction()
            }
        
        case "SHOW_EXTRACTED_MESSAGE":
            print("SHOW_EXTRACTED_MESSAGE = ", self.extractedText)
            DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
                self.onRequestShowMessage?(action.informationTitle, self.extractedText, action.accessCalendar){
                    self.extractedText = ""
                    self.processNextAction()
             }
            /*onRequestShowMessage?(action.informationTitle, self.extractedText, action.accessCalendar ?? false){
                self.extractedText = ""
                self.processNextAction()*/
            }
            
        case "NAVIGATE_WEB":
            print("Entered NAVIGATE_WEB")
            navigateToPage(urlString: action.websiteUrl)
            
        case "CLICK_ELEMENT_CLASS":
            print("Entered CLICK_ELEMENT_CLASS")
            clickElementClass(withClass: action.jsElementKey, willNavigate: action.willNavigate)
            /*DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
             self.clickElementClass(withClass: action.parameter)
             }*/
        case "CLICK_ELEMENT_XPATH":
            print("Entered CLICK_ELEMENT_XPATH")
            //clickElementByXPath(xpath: action.jsElementKey, willNavigate: action.willNavigate )
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { //bara test
             self.clickElementByXPath(xpath: action.jsElementKey, willNavigate: action.willNavigate )
             }
        case "EXTRACT_TEXT_XPATH":
            print("Entered EXTRACT_TEXT_XPATH")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { //bara test
                self.extractTextByXPath(xpath: action.jsElementKey)
            }
            
        case "INSERT_ELEMENT_XPATH":
            //print("INSERT_ELEMENT_XPATH")
            //fillElementByXPath(xpath: action.jsElementKey, willNavigate: action.willNavigate, valueType: action.extractFromUser)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { //bara test
                self.userSession.valueToIbject = action.valueToInject ?? ""
                print ("Value injected: \(self.userSession.valueToIbject)")
                self.fillElementByXPath(xpath: action.jsElementKey, willNavigate: action.willNavigate, valueType: action.extractFromUser)
             }
            
        case "INSERT_ELEMENT_CLASS":
            print("INSERT_ELEMENT_CLASS")
            fillElementByClass(className: action.jsElementKey, willNavigate: action.willNavigate, valueType: action.extractFromUser )
            /*DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) { //bara test
             self.fillElementByClass(className: action.jsElementKey, willNavigate: action.willNavigate, valueType: action.extractFromUser )
             }*/
            
        case "EXTRACT_LIST_BY_XPATH":
                print("EXTRACT_LIST_BY_XPATH")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.extractListItemsByXPath(xpath: action.jsElementKey)
            }
            
            
        case "CLICK_ELEMENT_CLASS_HIGHLIGHT":
            //clickElementClassHighlight(withClass: action.jsElementKey, willNavigate: action.willNavigate)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
             self.clickElementClassHighlight(withClass: action.jsElementKey, willNavigate: action.willNavigate)
             }
            
        case "CLICK_ELEMENT_XPATH_HIGHLIGHT":
            //clickElementByXPathHighlight(xpath: action.jsElementKey, willNavigate: action.willNavigate)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.clickElementByXPathHighlight(xpath: action.jsElementKey, willNavigate: action.willNavigate)
            }
        
        case "WAIT_FOR_MANUAL_NAVIGATION":
            waitForWebChange()
            
        case "SCROLL_TO_ELEMENT_AND_SHOW_TEXT":
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.scrollToElementAndShowText(xpath: action.jsElementKey, explanationText: action.descriptionMessage)
            }
            
        case "EXTRACT_BOOKED_TIMES_1177":
            extractBookedTimes1177(xpath: action.jsElementKey)
            
            
        case "INSERT_ELEMENT_ID":
            self.userSession.valueToIbject = action.valueToInject ?? ""
            print("INSERT_ELEMENT_ID")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.fillElementById(id: action.jsElementKey, willNavigate: action.willNavigate, valueType: action.extractFromUser)
            }
        case "FILL_GOOGLE_SEARCH_BOX":
            fillGoogleSearchBox(xpath: action.jsElementKey, valueType: action.extractFromUser, willNavigate: action.willNavigate)
            
        default:
            print("Unknown action: \(action.functionToCall)")
            processNextAction()
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {

        if isNavigating {
            if webView.url != lastPageURL {
                isNavigating = false
                processNextAction()
            } else {
                print("Only refresh")
            }
            return // vänta på navigation
        }
        if !isWaitingForUserInput {
            processNextAction()
        }
    }
    
    func addActions(_ actions: [WebAction], onComplete: (() -> Void)? = nil) {
        //print("action is called")
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
    
    private func extractBookedTimes1177(xpath: String) {
        let js = """
        (function() {
            console.log = (function(originalLog) {
                return function(message) {
                    originalLog(message);
                    try {
                        window.webkit.messageHandlers.callbackHandler.postMessage('[JS LOG] ' + message);
                    } catch (e) {
                        originalLog('Failed to forward log:', e);
                    }
                };
            })(console.log);

            function postError(msg) {
                console.log('[JS ERROR] ' + msg);
                try {
                    window.webkit.messageHandlers.errorHandler.postMessage('[JS ERROR] ' + msg);
                } catch (e) {
                    console.log('Failed to post error: ' + e);
                }
            }

            const alert = document.querySelector('ids-alert');
            if (!alert) return postError('ids-alert not found');

            const shadow = alert.shadowRoot;
            if (!shadow) return postError('Shadow root not found on ids-alert');

            // Extract <h2 slot="headline">
            const headlineSlot = shadow.querySelector('slot[name="headline"]');
            let headlineText = '';
            if (headlineSlot) {
                const assigned = headlineSlot.assignedNodes({ flatten: true });
                headlineText = assigned.map(n => (n.textContent || '').trim()).filter(Boolean).join(' ');
            }

            // Extract <slot> (body content)
            const bodySlot = shadow.querySelector('slot:not([name])'); // unnamed slot
            let bodyText = '';
            if (bodySlot) {
                const assigned = bodySlot.assignedNodes({ flatten: true });
                bodyText = assigned
                    .filter(n => n.nodeType === Node.ELEMENT_NODE || n.nodeType === Node.TEXT_NODE)
                    .map(n => (n.textContent || '').trim())
                    .filter(Boolean)
                    .join('\\n\\n');
            }

            const finalText = [headlineText, bodyText].filter(Boolean).join('\\n\\n');

            if (!finalText || finalText.length < 10) {
                return postError('Extracted text is too short or empty');
            }

            window.webkit.messageHandlers.callbackHandler.postMessage('ExtractedText:' + finalText);
        })();
        """

        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.webView.evaluateJavaScript(js) { _, error in
                if let error = error {
                    print("JavaScript injection error: \(error.localizedDescription)")
                }
                // No processNextAction here — handled by callbackHandler
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
        isNavigating = navigate
        let valueToInsert = valueType.getValue(session: userSession)
        
        // Escape single quotes in the value to prevent JS errors
        let escapedValue = valueToInsert.replacingOccurrences(of: "'", with: "\\'")
        
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
                element.dispatchEvent(spaceEvent);

                window.webkit.messageHandlers.callbackHandler.postMessage('Filled element with class: ' + className + ' and value: ' + value + ' and simulated Space key.');
            } else {
                console.log('Element not found by class, retrying...');
                setTimeout(function() { waitForElementByClass(className, value); }, 500);
            }
        }
        waitForElementByClass('\(className)', '\(escapedValue)');
        """

        webView.evaluateJavaScript(js) { _, error in
            if let error = error {
                print("JavaScript injection error: \(error.localizedDescription)")
            }
            if !self.isNavigating {
                self.processNextAction()
            }
        }
    }
    
    private func fillElementById(id: String, willNavigate navigate: Bool, valueType: ExtractFromUser) {
        isNavigating = navigate
        
        let valueToInsert = valueType.getValue(session: userSession)
        
        let escapedValue = valueToInsert.replacingOccurrences(of: "'", with: "\\'")
        
        let js = """
        function waitForElementById(id, value) {
            var element = document.getElementById(id);
            
            if (element) {
                console.log('Element found using ID, filling value...');
                element.focus();
                element.value = value;

                ['input', 'change', 'keydown', 'keyup', 'blur'].forEach(function(eventType) {
                    var event = new Event(eventType, { bubbles: true });
                    element.dispatchEvent(event);
                });

                window.webkit.messageHandlers.callbackHandler.postMessage('Filled element with ID: ' + id + ' and value: ' + value);
            } else {
                console.log('Element not found by ID, retrying...');
                setTimeout(function() { waitForElementById(id, value); }, 500);
            }
        }
        waitForElementById('\(id)', '\(escapedValue)');
        """

        webView.evaluateJavaScript(js) { _, error in
            if let error = error {
                print("JavaScript injection error: \(error.localizedDescription)")
            }
            if !self.isNavigating {
                self.processNextAction()
            }
        }
    }
    
    private func fillElementByXPathComplicated(id: String, willNavigate navigate: Bool, valueType: ExtractFromUser) {
        
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
        waitForElementById('\(id)', '\(valueToInsert)');
        """
        
        webView.evaluateJavaScript(js) { _, error in
            if let error = error {
                print("JavaScript injection error: \(error.localizedDescription)")
            }
            self.processNextAction()
        }
    }
    
    //inte klar
    private func fillElementByXPath(xpath: String, willNavigate navigate: Bool, valueType: ExtractFromUser) {
        isNavigating = navigate
        
        let valueToInsert = valueType.getValue(session: userSession)
        print("USER INPUT IN FUNCTION: \(valueToInsert)")
        
        let escapedValue = valueToInsert.replacingOccurrences(of: "'", with: "\\'")
        
        let js = """
        function waitForElementByXPath(xpath, value) {
            var result = document.evaluate(xpath, document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
            var element = result.singleNodeValue;
            
            if (element) {
                console.log('Element found using XPath, filling value...');
                element.focus();
                element.value = value;

                ['input', 'change', 'keydown', 'keyup', 'blur'].forEach(function(eventType) {
                    var event = new Event(eventType, { bubbles: true });
                    element.dispatchEvent(event);
                });

                window.webkit.messageHandlers.callbackHandler.postMessage('Filled element with XPath: ' + xpath + ' and value: ' + value);
            } else {
                console.log('Element not found by XPath, retrying...');
                setTimeout(function() { waitForElementByXPath(xpath, value); }, 500);
            }
        }
        waitForElementByXPath('\(xpath)', '\(escapedValue)');
        """

        webView.evaluateJavaScript(js) { _, error in
            if let error = error {
                print("JavaScript injection error: \(error.localizedDescription)")
            }
            if !self.isNavigating {
                self.processNextAction()
            }
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
        (function() {
            var maxWaitTime = 10000;
            var intervalTime = 500;
            var elapsed = 0;

            function waitForElement(xpath) {
                var element = document.evaluate(xpath, document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue;
                
                if (element) {
                    console.log('Element found using XPath, clicking...');
                    element.click();
                    window.webkit.messageHandlers.callbackHandler.postMessage('Clicked element with XPath: ' + xpath);
                } else if (elapsed >= maxWaitTime) {
                    console.log('Timeout: Element not found within max wait time');
                    window.webkit.messageHandlers.errorHandler.postMessage('FAILED_TO_FIND_ELEMENT_WITH_XPATH: ' + xpath);
                } else {
                    elapsed += intervalTime;
                    setTimeout(function() { waitForElement(xpath); }, intervalTime);
                }
            }

            waitForElement('\(xpath)');
        })();
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
    
    //Klar
    private func waitForWebChange() {
        lastPageURL = webView.url
        isNavigating = true
        print("Currrent URL: \(lastPageURL?.absoluteString ?? "empty")")
    }
    
    private func extractTextBySelector(selector: String) {
        let js = """
        function waitAndExtract(selector) {
            const container = document.querySelector(selector);
            if (!container) {
                console.log('Selector not found: ' + selector + ', retrying...');
                setTimeout(() => waitAndExtract(selector), 500);
                return;
            }

            const idsAlert = container.querySelector('ids-alert');
            if (!idsAlert || !idsAlert.shadowRoot) {
                console.log('ids-alert or shadowRoot not found, retrying...');
                setTimeout(() => waitAndExtract(selector), 500);
                return;
            }

            const textDiv = idsAlert.shadowRoot.querySelector('div.text');
            if (!textDiv) {
                console.log('Text container not found in shadow DOM, retrying...');
                setTimeout(() => waitAndExtract(selector), 500);
                return;
            }

            const paragraphs = textDiv.querySelectorAll('p');
            let texts = [];
            paragraphs.forEach(p => {
                texts.push((p.innerText || p.textContent || '').trim());
            });

            const finalText = texts.join('\\n\\n');
            window.webkit.messageHandlers.callbackHandler.postMessage('ExtractedText:' + finalText);
        }

        waitAndExtract('\(selector)');
        """

        webView.evaluateJavaScript(js) { _, error in
            if let error = error {
                print("JavaScript injection error: \(error.localizedDescription)")
            }
            self.processNextAction()
        }
    }
    
    
    private func scrollToElementAndShowText(xpath: String, explanationText: String) {
        let js = """
        function waitForElementAndExplain(xpath, explanationText) {
            var result = document.evaluate(xpath, document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
            var element = result.singleNodeValue;

            if (element) {

                element.scrollIntoView({ behavior: 'smooth', block: 'center' });

                setTimeout(function() {
                    var rect = element.getBoundingClientRect();
                    
                    var blueColor = "rgba(0, 0, 255, 0.8)";
                    
                    var overlay = document.createElement("div");
                    overlay.style.position = "absolute";
                    overlay.style.top = (rect.top + window.scrollY + (rect.height / 2) - 50) + "px";
                    overlay.style.left = (rect.left + window.scrollX + (rect.width / 2) - 50) + "px";
                    overlay.style.width = "100px";
                    overlay.style.height = "100px";
                    overlay.style.backgroundColor = "rgba(0, 0, 255, 0.3)";
                    overlay.style.zIndex = "29998";
                    overlay.style.pointerEvents = "none";
                    overlay.style.borderRadius = "50%";
                    document.body.appendChild(overlay);

                    var textBox = document.createElement("div");
                    textBox.style.position = "absolute";
                    //textBox.style.top = (rect.bottom + window.scrollY + 10) + "px"; // 10px below the element
                    //textBox.style.left = (rect.left + window.scrollX) + "px";
                    textBox.style.top = (parseFloat(overlay.style.top) + 100 + 10) + "px"; // 10px below the circle
                    textBox.style.left = (parseFloat(overlay.style.left) - 50) + "px"; 
                    textBox.style.maxWidth = "300px";
                    textBox.style.padding = "10px";
                    textBox.style.backgroundColor = "#FFFFFF";
                    textBox.style.border = "2px solid " + blueColor;
                    textBox.style.borderRadius = "5px";
                    textBox.style.zIndex = "29999";
                    textBox.style.color = "#000000";
                    textBox.style.fontFamily = "Arial, sans-serif";
                    textBox.style.fontSize = "22px";
                    textBox.style.lineHeight = "1.5";
                    textBox.style.boxShadow = "0 2px 5px rgba(0,0,0,0.2)"; // Keeping subtle shadow for definition
                    textBox.innerHTML = explanationText;
                    document.body.appendChild(textBox);

                    if (rect.width > 300) {
                        textBox.style.width = rect.width + "px";
                    }

                    setTimeout(function() {
                        overlay.remove();
                        textBox.remove();
                        window.webkit.messageHandlers.callbackHandler.postMessage('Displayed explanation for element: ' + xpath);
                    }, 7000);
                }, 2000); // ändra till 1000 senare
                
            } else {
                console.log("Element not found, retrying...");
                setTimeout(function() { waitForElementAndExplain(xpath, explanationText); }, 1000);
            }
        }
        waitForElementAndExplain('\(xpath)', `\(explanationText)`);
        """
        
        webView.evaluateJavaScript(js) { _, error in
            if let error = error {
                print("JavaScript injection error: \(error.localizedDescription)")
                self.processNextAction()
            }
        }
    }
    
    private func scrollToElementAndShowTextId(id: String, explanationText: String) {
        let js = """
        function waitForElementAndExplain(id, explanationText) {
            var element = document.getElementById(id);

            if (element) {
                element.scrollIntoView({ behavior: 'smooth', block: 'center' });

                setTimeout(function() {
                    var rect = element.getBoundingClientRect();
                    
                    var blueColor = "rgba(0, 0, 255, 0.8)";
                    
                    var overlay = document.createElement("div");
                    overlay.style.position = "absolute";
                    overlay.style.top = (rect.top + window.scrollY + (rect.height / 2) - 50) + "px";
                    overlay.style.left = (rect.left + window.scrollX + (rect.width / 2) - 50) + "px";
                    overlay.style.width = "100px";
                    overlay.style.height = "100px";
                    overlay.style.backgroundColor = "rgba(0, 0, 255, 0.3)";
                    overlay.style.zIndex = "29998";
                    overlay.style.pointerEvents = "none";
                    overlay.style.borderRadius = "50%";
                    document.body.appendChild(overlay);

                    var textBox = document.createElement("div");
                    textBox.style.position = "absolute";
                    //textBox.style.top = (rect.bottom + window.scrollY + 10) + "px"; // 10px below the element
                    //textBox.style.left = (rect.left + window.scrollX) + "px";
                    textBox.style.top = (parseFloat(overlay.style.top) + 100 + 10) + "px"; // 10px below the circle
                    textBox.style.left = (parseFloat(overlay.style.left) - 50) + "px";
                    textBox.style.maxWidth = "300px";
                    textBox.style.padding = "10px";
                    textBox.style.backgroundColor = "#FFFFFF";
                    textBox.style.border = "2px solid " + blueColor;
                    textBox.style.borderRadius = "5px";
                    textBox.style.zIndex = "29999";
                    textBox.style.color = "#000000";
                    textBox.style.fontFamily = "Arial, sans-serif";
                    textBox.style.fontSize = "22px";
                    textBox.style.lineHeight = "1.5";
                    textBox.style.boxShadow = "0 2px 5px rgba(0,0,0,0.2)"; // Keeping subtle shadow for definition
                    textBox.innerHTML = explanationText;
                    document.body.appendChild(textBox);

                    if (rect.width > 300) {
                        textBox.style.width = rect.width + "px";
                    }

                    setTimeout(function() {
                        overlay.remove();
                        textBox.remove();
                        window.webkit.messageHandlers.callbackHandler.postMessage('Displayed explanation for element: ' + id);
                    }, 7000);
                }, 2000); // ändra till 1000 senare
                
            } else {
                console.log("Element not found, retrying...");
                setTimeout(function() { waitForElementAndExplain(id, explanationText); }, 1000);
            }
        }
        waitForElementAndExplain('\(id)', `\(explanationText)`);
        """
        
        webView.evaluateJavaScript(js) { _, error in
            if let error = error {
                print("JavaScript injection error: \(error.localizedDescription)")
                self.processNextAction()
            }
        }
    }
    
    private func requestUserInput(title: String, prompt: String) {
        self.isWaitingForUserInput = true
        onRequestUserInput?(title, prompt) { [weak self] userInput in
            guard let self = self else { return }
            
            self.userSession.userInput = userInput
            print("Saved user input: \(userInput)")
            self.isWaitingForUserInput = false
            self.processNextAction()
        }
    }
    
    private func fillGoogleSearchBox(xpath: String, valueType: ExtractFromUser, willNavigate navigate: Bool) {
        isNavigating = navigate
        let searchText = valueType.getValue(session: userSession)
        let escapedValue = searchText.replacingOccurrences(of: "'", with: "\\'")
        
        let js = """
            function fillGoogleSearchBox(searchText) {
                // Try EVERY possible method to find the search input
                var searchElements = [
                    document.querySelector('input[name="q"]'),
                    document.querySelector('textarea[name="q"]'),
                    document.querySelector('.gLFyf'),
                    document.getElementById('APjFqb'),
                    document.querySelector('input[type="search"]'),
                    document.querySelector('input[title="Sök"]'),
                    document.querySelector('input[aria-label="Sök"]'),
                    document.querySelector('textarea[aria-label="Sök"]')
                ];
                
                // Find first non-null element
                var searchBox = null;
                for (var i = 0; i < searchElements.length; i++) {
                    if (searchElements[i]) {
                        searchBox = searchElements[i];
                        console.log("Found search box using method #" + (i+1));
                        break;
                    }
                }
                
                if (searchBox) {
                    try {
                        console.log('Google search box found, filling search...');
                        searchBox.focus();
                        searchBox.value = searchText;
                        
                        // Trigger events
                        ['input', 'change', 'keydown', 'keyup', 'blur'].forEach(function(eventType) {
                            var event = new Event(eventType, { bubbles: true });
                            searchBox.dispatchEvent(event);
                        });
                        
                        // Form submission might be more reliable than Enter key
                        var form = searchBox.closest('form');
                        if (form) {
                            form.submit();
                        } else {
                            // Fallback to Enter key
                            var enterEvent = new KeyboardEvent('keydown', {
                                bubbles: true,
                                cancelable: true,
                                key: 'Enter',
                                code: 'Enter',
                                keyCode: 13
                            });
                            searchBox.dispatchEvent(enterEvent);
                        }
                        
                        window.webkit.messageHandlers.callbackHandler.postMessage('Google search performed with text: ' + searchText);
                        return true;
                    } catch (e) {
                        window.webkit.messageHandlers.errorHandler.postMessage('Error interacting with search box: ' + e.message);
                        return false;
                    }
                } else {
                    window.webkit.messageHandlers.errorHandler.postMessage('Could not find Google search box using any method');
                    return false;
                }
            }
            
            fillGoogleSearchBox('\(escapedValue)');
            """
        
        webView.evaluateJavaScript(js) { _, error in
            if let error = error {
                print("JavaScript error: \(error.localizedDescription)")
            }
        }
    }
}
