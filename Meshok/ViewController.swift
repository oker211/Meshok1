//
//  ViewController.swift
//  Meshok
//
//  Created by Филипп Слабодецкий on 27.08.2020.
//  Copyright © 2020 Filipp Slabodetsky. All rights reserved.
//

import UIKit
import SwiftSoup

class ViewController: UIViewController, XMLParserDelegate {
    
    //MARK:- Property
    
    var host = String()
    var url = String()
    var sessionid = "123"
    var urlPay = "https://sandbox3.payture.com/apim/Pay?SessionId="
    var urlPayment = String()
  
  
    
    //MARK:- ArgumentsUI
    
    @IBOutlet weak var logoPayture: UILabel!
    @IBOutlet weak var merchantTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var orderidTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var textView: UITextView!
    
    
    //MARK:- ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        host = "https://sandbox3.payture.com/"
        
    }


    //MARK:- Action
    
    @IBAction func actionSegmented(_ sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            host = "https://sandbox3.payture.com/"
            urlPay = "https://sandbox3.payture.com/apim/Pay?SessionId="
        case 1:
            host = "https://secure.payture.com/"
            urlPay = "https://secure.payture.com//apim/Pay?SessionId="
        default:
            break
        }
    }
    
    @IBAction func openBrowser(_ sender: UIButton) {
        
        sumUrlID()
        
    }
    
    
    
    @IBAction func blockButton(_ sender: UIButton) {
        if  merchantTextField.text!.isEmpty {
              sender.isEnabled = true
            self.merchantTextField.text = "?????"
            self.merchantTextField.textColor = .red
          }  else if amountTextField.text!.isEmpty {
                  sender.isEnabled = true
            self.amountTextField.text = "?????"
            self.amountTextField.textColor = .red
              } else {
                   sendBlock()
          }
    }
    //
    
    @IBAction func payButton(_ sender: UIButton) {
        
        if  merchantTextField.text!.isEmpty {
            sender.isEnabled = true
          self.merchantTextField.text = "?????"
            self.merchantTextField.textColor = .red
        }  else if amountTextField.text!.isEmpty {
                sender.isEnabled = true
          self.amountTextField.text = "?????"
            self.amountTextField.textColor = .red
            } else {
                 sendPay()
        }
    }
    
    @IBAction func refundButton(_ sender: UIButton) {
        if passwordTextField.text!.isEmpty && orderidTextField.text!.isEmpty && merchantTextField.text!.isEmpty && amountTextField.text!.isEmpty {
                  sender.isEnabled = true
          } else {
              sendRefund()
      }
    }
        
    @IBAction func unblockButton(_ sender: UIButton) {
        
        if passwordTextField.text!.isEmpty && orderidTextField.text!.isEmpty && merchantTextField.text!.isEmpty && amountTextField.text!.isEmpty {
                         sender.isEnabled = true
                 } else {
                     sendUnblock()
             }
    }
    
    @IBAction func statusButton(_ sender: UIButton) {
        sendStatus()
    }
    
    
    //MARK:- Methods
    

    
    func orderidRandom() -> String {
        let orderid = arc4random()
        return String(orderid)
    }
    
    
    
    
    
    func sendBlock() {
        
        let key = merchantTextField.text
        let orderID = orderidRandom()
        orderidTextField.text = orderID
        let amount = amountTextField.text
        let urlBlock = "\(host)apim/Init?Key=\(key!)&Data=SessionType=Block;OrderId=\(orderID);Amount=\(amount!);"
        url = urlBlock
        print(url)
        getRequest()
        
        
        
    }

    func sendPay() {
        
        let key = merchantTextField.text
        let orderID = orderidRandom()
        orderidTextField.text = orderID
        let amount = amountTextField.text
        let urlPay = "\(host)apim/Init?Key=\(key!)&Data=SessionType=Pay;OrderId=\(orderID);Amount=\(amount!);"
        url = urlPay
        print(url)
        getRequest()
        
        
    }
    
    func sendRefund() {
        
        let key = merchantTextField.text
        let password = passwordTextField.text
        let orderID = orderidTextField.text
        let amount = amountTextField.text
        let urlRefund = "\(host)apim/Refund?Key=\(key!)&Password=\(password!)&OrderId=\(orderID!)&Amount=\(amount!)"
        url = urlRefund
        print(url)
        getRequest2()
    
    }
    
    func sendUnblock() {
          
          let key = merchantTextField.text
          let password = passwordTextField.text
          let orderID = orderidTextField.text
          let urlUnblock = "\(host)apim/Unblock?Key=\(key!)&Password=\(password!)&OrderId=\(orderID!)"
          url = urlUnblock
          print(url)
          getRequest2()
       
      }
    
    func sendStatus() {
        
        let key = merchantTextField.text
        let orderID = orderidTextField.text
        let urlStatus = "\(host)apim/GetState?Key=\(key!)&OrderId=\(orderID!)"
        url = urlStatus
        print(url)
        getRequest2()
        
    }
    
    
    
        
    func getRequest() {
     
        guard let urlRequest = URL(string: url) else {return}
        let session = URLSession.shared
        session.dataTask(with: urlRequest) { (data, response, error) in
            
            guard let data = data else {return}
            let xmlString = String(data: data, encoding: .utf8)
            DispatchQueue.main.async {
                self.textView.text = xmlString!
            }
            
        
           do {
    
    let doc: Document = try SwiftSoup.parse(xmlString!)
     let request: Element = try doc.select("Init").first()!
     let sessionID: String = try request.attr("SessionId")
    
    print(request)
    print(sessionID)
    
  self.sessionid = sessionID
          
                

   
    
} catch Exception.Error(type: let type, Message: let message) {
    print(type)
    print(message)
} catch {
    print(" ")
}
            
        }.resume()
        
    }
    
      func getRequest2() {
         
            guard let urlRequest = URL(string: url) else {return}
            let session = URLSession.shared
            session.dataTask(with: urlRequest) { (data, response, error) in
                
                guard let data = data else {return}
                let xmlString = String(data: data, encoding: .utf8)
                DispatchQueue.main.async {
                    self.textView.text = xmlString!
                }
                
            }.resume()
            
        }
    
    func sumUrlID() {
        
        self.urlPayment = self.urlPay + self.sessionid
        print(urlPayment)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "webView" else { return }
        guard let destination = segue.destination as? WebViewController else { return }
        destination.stringUrl = urlPayment
    }
}





