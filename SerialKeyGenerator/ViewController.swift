//
//  ViewController.swift
//  SerialKeyGenerator
//
//  Created by Jin HengJun on 2/8/19.
//  Copyright © 2019 Jin HengJun. All rights reserved.
//

import Cocoa
import IOKit
import CryptoSwift


extension String {
    var hexaBytes: [UInt8] {
        var position = startIndex
        return (0..<count/2).flatMap { _ in    // for Swift 4.1 or later use compactMap instead of flatMap
            defer { position = index(position, offsetBy: 2) }
            return UInt8(self[position...index(after: position)], radix: 16)
        }
    }
    var hexaData: Data { return hexaBytes.data }
}

extension Collection where Element == UInt8 {
    var data: Data {
        return Data(self)
    }
    var hexa: String {
        return map{ String(format: "%02X", $0) }.joined()
    }
}

class ViewController: NSViewController {
    
    @IBOutlet weak var textCode: NSTextField!
    @IBOutlet weak var textSerialNumber: NSTextField!
    
    let bytes: Array<UInt8> = "iMessageAppKey-6".bytes
    
    let key: Array<UInt8> = [0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00]

    var serialNumber:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textCode.isEditable = false
    }
    
    @IBAction func onGenerate(_ sender: Any) {
        serialNumber = textSerialNumber.stringValue
        while(serialNumber.count<16)
        {
            serialNumber.append(contentsOf: "0")
        }
        
        let iv = Array(serialNumber.utf8)
        
        do {
            let encrypted = try AES(key: key, blockMode: CBC(iv: iv), padding: .pkcs7).encrypt(bytes)
            
            let string = encrypted.toHexString()
            let b = string.hexaBytes
            let decrypted = try AES(key: key, blockMode: CBC(iv: iv), padding: .pkcs7).decrypt(encrypted)
            
            textCode.stringValue = string
            let stringDecoded = String(bytes: decrypted, encoding: .utf8)
            
            print(stringDecoded)
        } catch {
            print(error)
        }
    }
    
    

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

