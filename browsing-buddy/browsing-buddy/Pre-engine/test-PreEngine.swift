//
//  test-PreEngine.swift
//  browsing-buddy
//
//  Created by Denis Ureke on 2025-03-11.
//

struct ButtonData {
    let text: String
    let key: String
}

func orchestrator(key: String, webViewController: WebViewController?) -> [ButtonData] {
    
    let buttons1 = [
        ButtonData(text: "Navigera", key: "1"),
        ButtonData(text: "Navigera", key: "1"),
        //ButtonData(text: "Navigera", key: "1")
    ]
    let buttons2 = [
        ButtonData(text: "Uppdatera", key: "2")
    ]
    
    let actions1 = [
        //WebAction(functionToCall: "A", parameter: "https://www.jlt.se"),
        WebAction(functionToCall: "D", parameter: "jlt-icon-burger-alt-2"),
        WebAction(functionToCall: "D", parameter: "external", willNavigate: true),
        WebAction(functionToCall: "D", parameter: "sc-bwzfXH ebmuvs sc-htpNat ilEmnI", willNavigate: true),
        WebAction(functionToCall: "D", parameter: "btn -flex", willNavigate: true),
        //WebAction(functionToCall: "G", parameter: "/html/body/div[2]/div/div[2]/button[2]", willNavigate: true),
        //WebAction(functionToCall: "C", parameter: "email"),
        //WebAction(functionToCall: "C", parameter: "password")
    ]
    let actions2 = [
        WebAction(functionToCall: "A", parameter: "https://www.google.se"),
    ]
    
    let actions3 = [
        WebAction(functionToCall: "A", parameter: "https://www.jlt.se")
    ]
    
    let actions4 = [
        WebAction(functionToCall: "A", parameter: "https://www.google.se")
    ]
    
    if key == "2" {
        webViewController?.addActions(actions2)
        return buttons2
    }else if key == "1" {
        webViewController?.addActions(actions1)
        return buttons1
    }else if key == "3" {
        webViewController?.addActions(actions3)
        return buttons1
    }else{
        webViewController?.addActions(actions4)
        return buttons2
        
    }
}
