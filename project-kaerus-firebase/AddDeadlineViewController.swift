// ----------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// ----------------------------------------------------------------------------
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import Foundation
import UIKit

protocol DeadlinesItemDelegate {
	func insertItem(text : String, timeDue : NSDate)
}

class AddDeadlineViewController: UIViewController,  UIBarPositioningDelegate, UITextFieldDelegate, UINavigationControllerDelegate {
	
	@IBOutlet weak var text: UITextField!
	@IBOutlet weak var UserSetTime: UIDatePicker!
	@IBOutlet weak var saveButton: UIBarButtonItem!
	
	var delegate : DeadlinesItemDelegate?
	
	/*  This value is either passed by `MealTableViewController` in `prepareForSegue(_:sender:)`,
	or constructed as part of adding a new meal. */
	var deadline: Deadline?
	var deadlineComplete: Bool?
	var startDate: NSDate!
	var endDate: NSDate!
	var dateToShowInitially: NSDate!
	
	override func viewDidLoad()	{
		super.viewDidLoad()
		
		self.text.delegate = self
		
		UserSetTime.minimumDate = startDate
		UserSetTime.maximumDate = endDate
		
		// user wants to edit a deadline
		if let _ = deadline {
			navigationItem.title = "Edit Deadline"
			
			text.text = deadline?.text
			
			let timeFormatter = NSDateFormatter()
			timeFormatter.dateFormat = "yyyy-MM-dd HH:mmZ"
			let timeDue = timeFormatter.dateFromString((deadline?.timeDue)!)
			
			UserSetTime.date = timeDue!
			deadlineComplete = deadline?.complete
		}
		else { // user wants to add a deadline
			UserSetTime.date = dateToShowInitially
			deadlineComplete = false
			self.text.becomeFirstResponder()
		}
		
		// used to know when textfields are being written into
		text.addTarget(self, action: #selector(AddDeadlineViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
	}
	
	@IBAction func timePickerAction(sender: UIDatePicker) {
	}
	
	@IBAction func cancelPressed(sender : UIBarButtonItem) {
		if let _ = deadline { // push presentation; editing an item
			navigationController!.popViewControllerAnimated(true)
		} else { // modal presentation; adding an item
			dismissViewControllerAnimated(true, completion: nil)
		}
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if saveButton === sender {
			let deadlineName = text.text!
			let formatter = NSDateFormatter()
			formatter.dateFormat = "yyyy-MM-dd HH:mmZ"
			let timeDue = formatter.stringFromDate(UserSetTime.date)
			deadline = Deadline(text: deadlineName, timeDue: timeDue, complete: self.deadlineComplete!)
		}
	}
	
	func checkConditionsForSaveButton() {
		// Disable the Save button if the text field is empty.
		let input = text.text ?? ""
		saveButton.enabled = !input.isEmpty
	}
	
	func textFieldDidBeginEditing(textField: UITextField) {
		checkConditionsForSaveButton()
	}
	
	func textFieldDidChange(textField: UITextField) {
		checkConditionsForSaveButton()
	}
	
	func textFieldShouldEndEditing(textField: UITextField) -> Bool
	{
		return true
	}
	
	func textFieldShouldReturn(textField: UITextField) -> Bool
	{
		textField.resignFirstResponder()
		return true
	}
}