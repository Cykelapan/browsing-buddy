//
//  FunctionToCall.swift
//  browsing-buddy
//
//  Created by Adam Granlund on 2025-03-14.
//

import Foundation


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
    
    func getValue(jsKey: JSElementKeys) -> String?{
        switch self {
        case .INPUT_REQUEST, .SHOW_MESSAGE, .SHOW_EXTRACTED_MESSAGE , .NAVIGATE_WEB:
            return "Kvittar"
            
        // Kan vändas på beronde på nyckel som finns
        case .INSERT_ELEMENT_CLASS, .CLICK_ELEMENT_CLASS:
            return jsKey.classPath ?? jsKey.className
            
        case .CLICK_ELEMENT_XPATH, .EXTRACT_LIST_BY_XPATH, .EXTRACT_TEXT_XPATH, .INSERT_ELEMENT_XPATH:
            return jsKey.xPath
            
        }
    }
}
