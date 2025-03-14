//
//  test-PreEngine.swift
//  browsing-buddy
//
//  Created by Denis Ureke on 2025-03-11.
//

enum UserField: String{
    case email
    case password
    //lägger till fler sedan
}

func orchestrator(key: String, webViewController: WebViewController?) -> [ButtonData] {
    
    let buttons1 = [
        ButtonData(text: "Boka tid", key: "1"),
        //ButtonData(text: "Navigera", key: "1")
    ]
    let buttons2 = [
        ButtonData(text: "Uppdatera", key: "2")
    ]
    
    let actions1 = [
        /*//WebAction(functionToCall: "A", parameter: "https://www.jlt.se"),
        WebAction(functionToCall: "D", parameter: "jlt-icon-burger-alt-2"),
        WebAction(functionToCall: "D", parameter: "external", willNavigate: true),
        WebAction(functionToCall: "D", parameter: "sc-bwzfXH ebmuvs sc-htpNat ilEmnI", willNavigate: true),
        //WebAction(functionToCall: "D", parameter: "btn -flex", willNavigate: true),
        WebAction(functionToCall: "G", parameter: "/html/body/div[2]/div/div[2]/button[2]", willNavigate: true),
        //WebAction(functionToCall: "C", parameter: "email"),
        //WebAction(functionToCall: "C", parameter: "password")*/
        
        //WebAction(functionToCall: "A", parameter: "https://www.polisen.se"),
        WebAction(
            functionToCall: "G",
            parameter: "//*[@id=\\\"main-content\\\"]/div[2]/div[1]/div[1]/nav/div/ul/li[1]/a/span[3]/span",
            willNavigate: true
        ),
        WebAction(
            functionToCall: "G",
            parameter: "//*[@id=\\\"main-content\\\"]/div/div[2]/p[2]/span/a",
            willNavigate: true
        ),
        WebAction(
            functionToCall: "G",
            parameter: "//*[@id=\\\"main-content\\\"]/div/div[2]/div[2]/div/p[7]/a",
            willNavigate: true
        ),
        WebAction(
            functionToCall: "G",
            parameter: "//*[@id=\\\"Main\\\"]/div[2]/div[1]/div/form/div[2]/input",
            willNavigate: true
        ),
        WebAction(
            functionToCall: "G",
            parameter: "/html/body/main/div/div/div/div/div/a[1]",
            willNavigate: true
        ),
        WebAction(
            functionToCall: "SHOW_MESSAGE",
            parameter: "Nu är det snart dags att signera med BankID mm..",
            title: "BANKID"
        ),


    ]
    let actions2 = [
        
        WebAction(functionToCall: "SHOW_MESSAGE", parameter: "Du är på Google vid tryck navigeras du till Jönköpings Länstrafik"),
    ]
    
    let actions3 = [
        WebAction(functionToCall: "A", parameter: "https://www.polisen.se")
    ]
    
    let actions5 = [
         WebAction(functionToCall: "A", parameter: "https://www.google.se"),
         WebAction(
             functionToCall: "Insert_Element_Class",
             parameter: "gLFyf", // Class name of textarea
             extractFromUser: UserField.email.rawValue // skickar man in en string som inte finns i switch, är det det som fylls i
         )
        
        ]
    
    let actions4 = [
        WebAction(functionToCall: "A", parameter: "https://www.jonkoping.se/fritid-kultur--natur/motesplatser-och-fritidsgardar/aktiviteter-for-seniorer/fysiska-traffpunkter-for-seniorer/seniortorget-huskvarna-f.d.-traffpunkt-hornan"),
        //WebAction(functionToCall: "Extract_Message", parameter: "//*[@id=\"svid12_1a8263dd17545631d955d4\"]/div[2]/p"),
        //WebAction(functionToCall: "Extract_List_By_Xpath", parameter: "//*[@id=\"svid12_71cb585d1946405449610734\"]/div[2]/ul"),
        WebAction(functionToCall: "Extract_List_By_Xpath", parameter: "//*[@id=\"svid12_5d10a33b194d02baeae52ef5\"]/div[2]/ul"),
        WebAction(functionToCall: "SHOW_EXTRACTED_MESSAGE", parameter: "", accessCalendar: true)
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
