/*
* Copyright (c) 2015 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit
import FirebaseCrash
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: UIViewController {
	
	// MARK: UIViewController Lifecycle
	@IBAction func facebookLogin (sender: AnyObject){
		let facebookLogin = FBSDKLoginManager()
		facebookLogin.logOut()
		
		facebookLogin.logInWithReadPermissions(["email", "user_friends"], fromViewController: self, handler:{(facebookResult, facebookError) -> Void in
			if facebookError != nil {
				FIRCrashMessage("Facebook login failed. Error \(facebookError)")
			} else if facebookResult.isCancelled {
				FIRCrashMessage("Facebook login was cancelled.")
			} else {
				FIRCrashMessage("Facebook login success!")
				self.performSegueWithIdentifier("LoggedIn", sender: nil)
			}
		})
	}
	
	@IBAction func didTapPivacyPolicyButton(sender: AnyObject) {
		let privacy_page = "https://projectkaerus.wordpress.com/privacy-policy"
		let url = NSURL(string: privacy_page)!
		UIApplication.sharedApplication().openURL(url)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
}
