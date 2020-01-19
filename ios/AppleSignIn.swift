//
//  RNAppleSignIn.swift
//  AppleSignIn
//
//  Created by Den on 18.01.2020.
//

import AuthenticationServices
//import UIKit

@objc(RNAppleSignIn)
public class RNAppleSignIn: RCTEventDispatcher, ASAuthorizationControllerDelegate {
  
  @objc override public static func requiresMainQueueSetup() -> Bool {
    return true
  }
  
  func supportedEvents() -> [String]! {
    return [
      "signin",
    ]
  }
  
  @objc func signIn(_ userIdentifier: String, callback: RCTResponseSenderBlock) {
    //NSLog("- signIn() called, uid=", userIdentifier)
    
    if #available(iOS 13.0, *) {
      
      // check if already signed in:
      if (userIdentifier != "") {
        //print("- signIn() checking if already signed, loading from store")
        
        let email = RNAppleSignIn.load(account: userIdentifier, service: "email")
        let nick = RNAppleSignIn.load(account: userIdentifier, service: "nick")
        let givenName = RNAppleSignIn.load(account: userIdentifier, service: "givenName")
        let familyName = RNAppleSignIn.load(account: userIdentifier, service: "familyName")
        
        // in any case first name should be non-empty
        if (givenName != "") {
          
          print("- already signed in:\n\temail=", email)
          print("\tuserIdent: ",userIdentifier)
          print("\tnick: ",nick)
          print("\tgivenName: ", givenName)
          print("\tfamilyName: ", familyName)
          
          callback(["done"])
          
          self.sendAppEvent( withName: "signin", body: [
            "uid": userIdentifier,
            "email": email,
            "nick": nick,
            "givenName": givenName,
            "familyName": familyName,
          ])
          
          return
        }
      }
      
      let appleIDProvider = ASAuthorizationAppleIDProvider()
      let request = appleIDProvider.createRequest()
      request.requestedScopes = [.fullName, .email]

      let a = ASAuthorizationController(authorizationRequests: [request])
      a.delegate = self
      a.performRequests()
      
      callback(["done"])
    } else {
      callback(["ios-below-13-not-supported"])
    }
  }
  
  public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
  if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {

      let email = appleIDCredential.email ?? ""
      let userIdentifier = appleIDCredential.user
      let fullName = appleIDCredential.fullName
    
      let nick = fullName?.nickname ?? ""
      let givenName = fullName?.givenName ?? ""
      let familyName = fullName?.familyName ?? ""

      /* // for debug:
      print("- okay, signed in:\n\temail=", email)
      print("\tuserIdent: ",userIdentifier)
      print("\tnick: ",nick)
      print("\tgivenName: ", givenName)
      print("\tfamilyName: ", familyName)
      */
    
      self.sendAppEvent( withName: "signin", body: [
        "uid": userIdentifier,
        "email": email,
        "nick": nick,
        "givenName": givenName,
        "familyName": familyName,
      ])
    
      //print("- ok, saving data to secure store")
      RNAppleSignIn.save(account: userIdentifier, service: "givenName", value: givenName)
      RNAppleSignIn.save(account: userIdentifier, service: "familyName", value: familyName)
      RNAppleSignIn.save(account: userIdentifier, service: "nick", value: nick)
      RNAppleSignIn.save(account: userIdentifier, service: "email", value: email)
    }
  }
  
  public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    // Handle error.
    self.sendAppEvent( withName: "signin", body: [
      "error": error.localizedDescription,
    ])
  }
  
  private static func query(account: String, service: String) -> [String: AnyObject] {
      var query = [String: AnyObject]()
      query[kSecClass as String] = kSecClassGenericPassword
      query[kSecAttrService as String] = service as AnyObject?
      query[kSecAttrAccount as String] = account as AnyObject?
      return query
  }
  
  class func save(account: String, service: String, value: String) {
    let data = value.data(using: String.Encoding.utf8)!
    var item = query(account: account, service: service)
    item[kSecValueData as String] = data as AnyObject?

    // delete existing..
    SecItemDelete(item as CFDictionary)
    
    let status = SecItemAdd(item as CFDictionary, nil)

    //print("- save() ", service, "->", status)
  }
  
  class func load(account: String, service: String) -> String {
    var q = query(account: account, service: service)
    q[kSecMatchLimit as String] = kSecMatchLimitOne
    q[kSecReturnAttributes as String] = kCFBooleanTrue
    q[kSecReturnData as String] = kCFBooleanTrue

    // fetching item matching query
    var qRes: AnyObject?
    let status = withUnsafeMutablePointer(to: &qRes) {
        SecItemCopyMatching(q as CFDictionary, UnsafeMutablePointer($0))
    }

    // check if error
    if (status == errSecItemNotFound) { return "" }
    if (status != noErr) { return "" }
    if (qRes == nil) { return "" }
    
    // parse the value from query result
    let item = qRes as! [String: AnyObject]
    let data = item[kSecValueData as String] as! Data
    let value = String(data: data, encoding: String.Encoding.utf8) ?? ""
    return value
  }
}
