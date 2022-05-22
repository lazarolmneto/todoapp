//
//  FontGenerator.swift
//  GetirTodo
//
//  Created by Lazaro Neto on 05/05/22.
//

import Foundation
import UIKit

class FontGenerator {
    
    private enum Constants {
        
        static let defaultSize = CGFloat(14)
        static let defaultName = "STHeitiTC-Medium"
        static let defaultLigthName = "STHeitiTC-Light"
    }
    
    class func defaultFont(with size: CGFloat = Constants.defaultSize) -> UIFont {
        
        let font = UIFont(name: Constants.defaultName, size: size)
                    ?? UIFont.systemFont(ofSize: Constants.defaultSize)
        return font
    }
    
    class func defaultLigthFont(with size: CGFloat = Constants.defaultSize) -> UIFont {
        
        let font = UIFont(name: Constants.defaultLigthName, size: size)
                    ?? UIFont.systemFont(ofSize: Constants.defaultSize)
        return font
    }
}
