import UIKit
import Firebase

//ONLINE PAGE (Emergency Page)

class online: UIViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//LOGIN




class login: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    var ref = Firebase(url: "https://usericare.firebaseio.com")

    var ref1 = Firebase(url: "https://emticare.firebaseio.com")
    
    @IBOutlet weak var usernametext: UITextField!
    @IBOutlet weak var passwordtext: UITextField!
    
    
    @IBAction func loginbutton(sender: AnyObject) {
        
        
        
        
        activity.hidden = false
        activity.startAnimating()
        
        let username = usernametext.text
        let password = passwordtext.text
        
//        if (username == NSUserDefaults.standardUserDefaults().stringForKey("Username") && password == NSUserDefaults.standardUserDefaults().stringForKey("Password"))
//            {
//            //Success
//                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isUser")
//                NSUserDefaults.standardUserDefaults().synchronize()
//                self.dismissViewControllerAnimated(true, completion: nil)
//            print("success")
//            }
//        else
//        {
//            let myalert = UIAlertController(title: "Alert", message: "Incorrect Username or Password", preferredStyle: UIAlertControllerStyle.Alert)
//            
//            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
//            
//            myalert.addAction(ok)
//            self.presentViewController(myalert, animated: true, completion:nil)
//
//            print("katt gaya")
//            
//    }
    
        ref.authUser(username, password: password, withCompletionBlock: {
        error, authData in
            if error != nil
            {
                
                self.ref1.authUser(username, password: password, withCompletionBlock:
                    {
                        error, authData in
                        if error != nil
                        {
                        
            print("Unable to Sign In User")
                self.alert("Incorrect username or password")
                            
                        }
                        else
                        {
                            //to activate screen again
                            
                            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isEMT")
                            NSUserDefaults.standardUserDefaults().synchronize()
//                            self.performSegueWithIdentifier("back", sender: self)
//      
                             self.dismissViewControllerAnimated(true, completion: nil)
                            print("successfully logged in as EMT!")
                        
                        }
            })
            }
                
            else {
            
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isUser")
                NSUserDefaults.standardUserDefaults().synchronize()
                print("successfully logged in as User!")
                self.dismissViewControllerAnimated(true, completion: nil)
//                self.performSegueWithIdentifier("back", sender: self)
            }
        
        
        })
    
    }
    
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.usernametext.delegate = self
        self.passwordtext.delegate = self
        activity.hidden=true
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func alert(message: String)
    {
        let myalert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default)
            {
            action in self.activity.stopAnimating()
            }
        
        myalert.addAction(ok)
        self.presentViewController(myalert, animated: true, completion:nil)
    
    }
    
    //Reset Password
    
    @IBAction func forgotpassword(sender: AnyObject) {
        ref.resetPasswordForUser(usernametext.text, withCompletionBlock: {
        error in
            if(error != nil)
            {
            print("Error in sending reset email")
            self.alert("check E-mail entered")
            }
            else
            {
            print("Password reset mail sent successfully")
                self.alert("Reset mail sent successfully")
            }
        
        })
        
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
}


//HOME PAGE

class home: UIViewController {
    
    override func viewDidAppear(animated: Bool) {
        
        if(NSUserDefaults.standardUserDefaults().boolForKey("isUser"))
        {
        self.performSegueWithIdentifier("homeView", sender: self)
        
        }
        else if(NSUserDefaults.standardUserDefaults().boolForKey("isEMT"))
        {
        self.performSegueWithIdentifier("emtView", sender: self)
        }
            
        else
        {
        self.performSegueWithIdentifier("loginView", sender: self)
        }
    }
    
}

//SETTINGS

class settings: UIViewController
{
    @IBAction func logout(sender: AnyObject) {
        
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isUser")
    }

}





//OFFLINE CALLING


class offline: UIViewController
{

    @IBAction func makecall(sender: AnyObject) {
        
        let url: NSURL = NSURL(string:"tel://+919958685355")!
        UIApplication.sharedApplication().openURL(url)
        
    }
    @IBAction func makecall2(sender: AnyObject) {
        let url: NSURL = NSURL(string:"tel://+919910086263")!
        UIApplication.sharedApplication().openURL(url)
    }

}




//SIGN-UP PAGE

class signUP: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    //Picker View for BLOOD GROUP
    var ref = Firebase(url: "https://usericare.firebaseio.com")

    @IBOutlet weak var usernametext: UITextField!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var mobiletext: UITextField!
    @IBOutlet weak var passwordtext: UITextField!
    @IBOutlet weak var confirmpasswordtext: UITextField!
    
    @IBOutlet weak var activity: UIActivityIndicatorView!

    @IBAction func submit(sender: AnyObject) {
        
        activity.startAnimating()
        
        let username = usernametext.text
        let mobile = mobiletext.text
        
        let password = passwordtext.text
        let confirmpassword = confirmpasswordtext.text
        
        //empty fields 
        
        func alert(userMessage: String)
        {
            let myalert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
            
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default)
                {
            
            action in self.activity.stopAnimating()
            }
            
            myalert.addAction(ok)
            self.presentViewController(myalert, animated: true, completion: nil)
        }
        
        if (username!.isEmpty || password!.isEmpty || mobile!.isEmpty || confirmpassword!.isEmpty)
        {
            alert("All fields are required")
        return
        }
        
        if(mobile!.characters.count != 10)
        {
            alert("Invalid Mobile number")
            return
        }
        
        if (password != confirmpassword)
        {
        
        alert(" Passwords do not match")
        return
        }
        
        
        //STORING DATA
        
//        NSUserDefaults.standardUserDefaults().setObject(username, forKey: "Username")
//        NSUserDefaults.standardUserDefaults().setObject(password, forKey: "Password")
//        NSUserDefaults.standardUserDefaults().setObject(mobile, forKey: "Mobile")
//        NSUserDefaults.standardUserDefaults().setObject(bloodgroup, forKey: "Blood Group")
//        NSUserDefaults.standardUserDefaults().synchronize()
        
//        let myalert = UIAlertController(title: "Alert", message: "Registration Successful", preferredStyle: UIAlertControllerStyle.Alert)
//       
//        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
//            action in self.dismissViewControllerAnimated(true, completion:nil)
//        }
        
//        myalert.addAction(ok)
//        self.presentViewController(myalert, animated: true, completion:nil)
    
    
//FIREBASE STORAGE
    
        
        
        
        
        ref.createUser(usernametext.text!, password: passwordtext.text!, withValueCompletionBlock: { error, result in
            
            if (error != nil)
            {
                
                alert("Invalid username or password")
                print("Something went wrong during User Sign Up")
                }
            else
            {
                let uid = result["uid"] as? String
                print("Successfully created user with UID \(uid)")
                self.ref.childByAppendingPath("Phone Number/\(uid)").setValue(mobile)
                self.ref.childByAppendingPath("Blood Group/\(uid)").setValue(self.bloodgroup)
                
              
                let myalert = UIAlertController(title: "Alert", message: "Registration Successful", preferredStyle: UIAlertControllerStyle.Alert)
                
                let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                    
                    action in self.dismissViewControllerAnimated(true, completion:nil)
                    self.activity.stopAnimating()
                }
                
                myalert.addAction(ok)
                self.presentViewController(myalert, animated: true, completion:nil)
                
            }
        
        })
        
    }
    
    var pickerData: [String] = [String]()
    
    
    
    
    override func viewDidLoad() {
        
        activity.hidden=true
        
        super.viewDidLoad()
        self.picker.delegate = self
        self.picker.dataSource = self
        pickerData = ["A+ve","A-ve","B+ve", "B-ve", "AB+ve","AB-ve","O+ve","O-ve"]
        self.usernametext.delegate = self  //To make keyboard return
        self.passwordtext.delegate = self
        self.mobiletext.delegate = self
        self.confirmpasswordtext.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    var bloodgroup: String = ""
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        bloodgroup = pickerData[row]
        return pickerData[row]
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

    
    
    
    
    
    //EMT
    
    
    
    
    

    
    class signupEMT: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate
    {
        
        @IBOutlet weak var activity: UIActivityIndicatorView!
        
        
    
         var ref = Firebase(url: "https://emticare.firebaseio.com/")
        
        
        @IBOutlet weak var usernametext: UITextField!
        @IBOutlet weak var myImageView: UIImageView!
        @IBOutlet weak var mobiletext: UITextField!
        
        @IBOutlet weak var passwordtext: UITextField!
        @IBOutlet weak var confirmpasswordtext: UITextField!
        
        var base64string: NSString = ""
        
        
        @IBAction func selectImage(sender: AnyObject) {
            
            let myPickerController = UIImagePickerController();
            myPickerController.delegate = self
            myPickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(myPickerController, animated: true, completion: nil)
        }
        
        func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
            myImageView.image = info[UIImagePickerControllerOriginalImage] as?UIImage
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        
        
        override func viewDidLoad() {
            
            activity.hidden = true
            
            self.usernametext.delegate = self  //To make keyboard return
            self.passwordtext.delegate = self
            self.mobiletext.delegate = self
            self.confirmpasswordtext.delegate = self
            
            
            super.viewDidLoad()
            // Do any additional setup after loading the view, typically from a nib.
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }

        @IBAction func submit(sender: AnyObject) {
            
            
            

//            var imageData: NSData =
//            UIImagePNGRepresentation(myImageView.image!)!
//            
//            self.base64string = imageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
//            
//            var quoteString = ["string": self.base64string]
//            var usersRef = ref.childByAppendingPath("Images")
//            var users = ["Image": quoteString]
//            
//            usersRef.setValue(users)
            
            activity.startAnimating()
            let username = usernametext.text
            let mobile = mobiletext.text
            
            let password = passwordtext.text
            let confirmpassword = confirmpasswordtext.text
            
            //empty fields
            
            func alert(userMessage: String)
            {
                let myalert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
                
                let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default)
                    {
                
                action in self.activity.stopAnimating()
                }
                
                myalert.addAction(ok)
                self.presentViewController(myalert, animated: true, completion: nil)
            }
            
            if (username!.isEmpty || password!.isEmpty || mobile!.isEmpty || confirmpassword!.isEmpty)
            {
                alert("All fields are required")
                return
            }
            
            if(mobile!.characters.count != 10)
            {
                alert("Invalid Mobile number")
                return
            }
            
            if (password != confirmpassword)
            {
                
                alert(" Passwords do not match")
                return
            }
        
        //
        
        ref.createUser(usernametext.text!, password: passwordtext.text!, withValueCompletionBlock: { error, result in
        
        if (error != nil)
        {
        
        alert("Invalid username or password")
        print("Something went wrong during User Sign Up")
        }
        else
        {
        let uid = result["uid"] as? String
        print("Successfully created user with UID \(uid)")
        self.ref.childByAppendingPath("Phone Number/\(uid)").setValue(mobile)
        // self.ref.childByAppendingPath("Blood Group/\(uid)").setValue(self.bloodgroup)

        
        let myalert = UIAlertController(title: "Alert", message: "Registration Successful", preferredStyle: UIAlertControllerStyle.Alert)
            
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                action in self.dismissViewControllerAnimated(true, completion:nil)
                self.activity.stopAnimating()
            }
            
            myalert.addAction(ok)
            self.presentViewController(myalert, animated: true, completion:nil)
            
            }
            
        })
        
        }


        func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
            textField.resignFirstResponder()
            return true
        }
        
        override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
            self.view.endEditing(true)
        }
      
}





//EMT TUTORIALS PAGE

class tutorials : UIViewController
{
    
    @IBOutlet weak var video: UIWebView!
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
    }
    
    
    @IBAction func cutButton(sender: AnyObject) {
        let youtubeURL = "https://www.youtube.com/embed/4e7evinsfm0"
        
        video.loadHTMLString("<iframe width=\"280\" height=\"266\" src=\"\(youtubeURL)\" frameborder=\"0\" allowfullscreen></iframe>", baseURL: nil)
    }
    @IBAction func cutPlayButton(sender: AnyObject) {
        let youtubeURL = "https://www.youtube.com/embed/4e7evinsfm0"
        
        video.loadHTMLString("<iframe width=\"280\" height=\"266\" src=\"\(youtubeURL)\" frameborder=\"0\" allowfullscreen></iframe>", baseURL: nil)
    }
   
    @IBAction func faintButton(sender: AnyObject) {
        
        let youtubeURL = "https://www.youtube.com/embed/uio90yWnYoE"
        
        video.loadHTMLString("<iframe width=\"280\" height=\"266\" src=\"\(youtubeURL)\" frameborder=\"0\" allowfullscreen></iframe>", baseURL: nil)
        
    }
    @IBAction func faintPlayButton(sender: AnyObject) {
        let youtubeURL = "https://www.youtube.com/embed/uio90yWnYoE"
        
        video.loadHTMLString("<iframe width=\"280\" height=\"266\" src=\"\(youtubeURL)\" frameborder=\"0\" allowfullscreen></iframe>", baseURL: nil)
        
    }
    
    @IBAction func burn(sender: AnyObject) {
        
        let youtubeURL = "https://www.youtube.com/embed/2pVGG09VmfQ"
        
        video.loadHTMLString("<iframe width=\"300\" height=\"284\" src=\"\(youtubeURL)\" frameborder=\"0\" allowfullscreen></iframe>", baseURL: nil)
    }
    @IBAction func burnPlay(sender: AnyObject) {
        
        let youtubeURL = "https://www.youtube.com/embed/2pVGG09VmfQ"
        
        video.loadHTMLString("<iframe width=\"300\" height=\"284\" src=\"\(youtubeURL)\" frameborder=\"0\" allowfullscreen></iframe>", baseURL: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


//EMT SETTINGS

class emtsettings: UIViewController
{
    @IBAction func logout(sender: AnyObject) {
        
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isEMT")
    }


}

