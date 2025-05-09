//
//  FunctionToCall.swift
//  browsing-buddy
//
//  Created by Adam Granlund on 2025-03-14.
//

import Foundation


/*

{
    "website": "Jönköping Kommun",
    "state": "Text",
    "device": "iPhone",
    
    "webCommands": {
        "websiteUrl" : "https://www.jonkoping.se/fritid-kultur--natur/motesplatser-och-fritidsgardar/aktiviteter-for-seniorer/fysiska-traffpunkter-for-seniorer/seniortorget-huskvarna-f.d.-traffpunkt-hornan",
        "functionToCall" : "NAVIGATE_WEB",
        "extractFromUser" : "NOTHING",
        "informationTitle": "",
        "willNavigate" : true,
        "jsElmentKeys" : {
            "className" : null,
            "classPath" : null,
            "elementId" : null,
            "elementTag" : null,
            "cssSelector" : null,
            "xPath" : null
        }
    }, {
        
        "websiteUrl" : "https://www.jonkoping.se/fritid-kultur--natur/motesplatser-och-fritidsgardar/aktiviteter-for-seniorer/fysiska-traffpunkter-for-seniorer/seniortorget-huskvarna-f.d.-traffpunkt-hornan",
        "functionToCall" : "EXTRACT_LIST_BY_XPATH",
        "extractFromUser" : "NOTHING",
        "informationTitle": "",
        "willNavigate" : false,
        "jsElmentKeys" : {
            "className" : null,
            "classPath" : null,
            "elementId" : null,
            "elementTag" : null,
            "cssSelector" : null,
            "xPath" : "//*[@id=\"svid12_5d10a33b194d02baeae52ef5\"]/div[2]/ul"
        }
    }, {
        "websiteUrl" : "https://www.jonkoping.se/fritid-kultur--natur/motesplatser-och-fritidsgardar/aktiviteter-for-seniorer/fysiska-traffpunkter-for-seniorer/seniortorget-huskvarna-f.d.-traffpunkt-hornan",
        "functionToCall" : "SHOW_EXTRACTED_MESSAGE",
        "extractFromUser" : "NOTHING",
        "informationTitle": "",
        "willNavigate" : false,
        "accessCalander": true
        "jsElmentKeys" : {
            "className" : "null",
            "classPath" : "null",
            "elementId" : "null",
            "elementTag" : "null",
            "cssSelector" : "null",
            "xPath" : "null"
            
        }
    }
        
}
*/*/

enum FunctionToCall : String, Codable {
    case INPUT_REQUEST = "INPUT_REQUEST"
    case SHOW_MESSAGE = "SHOW_MESSAGE"
    case SHOW_EXTRACTED_MESSAGE = "SHOW_EXTRACTED_MESSAGE"
 
    
    case NAVIGATE_WEB = "NAVIGATE_WEB"
    case CLICK_ELEMENT_CLASS = "CLICK_ELEMENT_CLASS"
    case INSERT_ELEMENT_CLASS = "INSERT_ELEMENT_CLASS"
    
    case CLICK_ELEMENT_XPATH = "CLICK_ELEMENT_XPATH"
    case EXTRACT_TEXT_XPATH = "EXTRACT_TEXT_XPATH"
    case EXTRACT_LIST_BY_XPATH = "EXTRACT_LIST_BY_XPATH"
    case INSERT_ELEMENT_XPATH = "INSERT_ELEMENT_XPATH"
    
    case CLICK_ELEMENT_CLASS_HIGHLIGHT = "CLICK_ELEMENT_CLASS_HIGHLIGHT"
    case CLICK_ELEMENT_XPATH_HIGHLIGHT = "CLICK_ELEMENT_XPATH_HIGHLIGHT"
    
    func getValue(jsKey: JSElementKeys) -> String?{
        switch self {
        case .INPUT_REQUEST, .SHOW_MESSAGE, .SHOW_EXTRACTED_MESSAGE , .NAVIGATE_WEB:
            return "Kvittar"
            
        // Kan vändas på beronde på nyckel som finns
        case .INSERT_ELEMENT_CLASS, .CLICK_ELEMENT_CLASS:
            return jsKey.classPath ?? jsKey.className
            
        case .CLICK_ELEMENT_XPATH, .EXTRACT_LIST_BY_XPATH, .EXTRACT_TEXT_XPATH, .INSERT_ELEMENT_XPATH, .CLICK_ELEMENT_CLASS_HIGHLIGHT, .CLICK_ELEMENT_XPATH_HIGHLIGHT :
            return jsKey.xPath
            
        }
    }
}
