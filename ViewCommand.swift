//
//  ViewCommand.swift
//  version 0.1
//
//  Copyright 2015 Narciso Cerezo Jiménez
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

import Foundation
import UIKit

/// Simplifies showing view controllers wihtout segues and across StoryBoard boundaries
class ViewCommand {
  
  private static var _commands: NSDictionary?
  private static var commands: NSDictionary? {
    get {
      if _commands == nil {
        if let path = NSBundle.mainBundle().pathForResource("ViewCommands", ofType: "plist") {
          _commands = NSDictionary(contentsOfFile: path)
          if _commands == nil {
            NSLog("Can't load ViewCommands.plist")
          }
        }
        else {
          NSLog("ViewCommands.plist not found")
        }
      }
      return _commands
    }
  }

  /// the associated view controller
  var viewController:UIViewController!
  
  /**
    Create a new ViewCommand given its name. You must have defined it as a dictionary with storyboard and view keys in the ViewCommands.plist file in your project.
  
    :param: name the name of the command
    :returns: ViewCommand if found and successfully loaded the ViewController, nil otherwise
  */
  init?( name: String) {
    if let commands = ViewCommand.commands,
      let command = commands[name] as? NSDictionary,
      let storyboardName = command["storyboard"] as? String,
      let viewName = command["view"] as? String
    {
      let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
      if let controller = storyboard.instantiateViewControllerWithIdentifier(viewName) as? UIViewController {
        self.viewController = controller
      }
      else {
        NSLog("Can't instantiate view controller with id: \(viewName)")
        return nil
      }
    }
    else {
      NSLog("Can't find command for name \(name) or not properly configured")
      return nil
    }
  }
  
  /**
    Show the view controller.
    It will simply showViewController for iOS 8.0, and for iOS 7 it will pushi it if the sender has a NavigationController (or is a NavigationController) or presenting it modally otherwise.
  
    :param: sender the sender of the command, a UIViewController
    :param: animated, boolean default to true (only for iOS 7)
  */
  func push( sender: UIViewController, animated: Bool? = true ) {
    if floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1 {
      if sender.navigationController != nil {
        sender.navigationController!.pushViewController( self.viewController, animated: animated! )
      }
      else if let navController = sender as? UINavigationController {
        navController.pushViewController( self.viewController, animated: animated! )
      }
      else {
        sender.presentViewController( self.viewController, animated: animated!, completion: nil )
      }
    }
    else {
      sender.showViewController( self.viewController, sender: sender )
    }
  }
}