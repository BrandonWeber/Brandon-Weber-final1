//
//  ViewController.swift
//  Brandon Weber final
//
//  Created by Brandon Weber on 4/13/23.
//


import UIKit
import CoreLocation
import MessageUI
import WebKit
import SafariServices


//tab 1 - location, web view and gps
class LocationViewController: UIViewController, CLLocationManagerDelegate {
   
    //This class has the code for the distance finder
    @IBOutlet var distanceLabel: UILabel!
    
    let locationManager: CLLocationManager = CLLocationManager()
    var startLocation:CLLocation!
    
    let eventLatitude: CLLocationDegrees = 40.7099
    let eventLongitude: CLLocationDegrees = -73.9851
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation: CLLocation=locations[0]
        
        if newLocation.horizontalAccuracy >= 0{
            let event:CLLocation = CLLocation(latitude: eventLatitude, longitude: eventLongitude)
            let change: CLLocationDistance = event.distance(from: newLocation)
            let miles: Double = (change * 0.0000621371) + 0.5
            if miles < 3 {
                locationManager.stopUpdatingLocation()
                distanceLabel.text = "You have Arrived!"
            }else{
                let commaFormat: NumberFormatter = NumberFormatter()
                commaFormat.numberStyle = NumberFormatter.Style.decimal
                distanceLabel.text = "You are " + commaFormat.string(from: NSNumber(value: miles))!+" Miles to the event!"
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    //Distance Finder
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.distanceFilter =  1609;
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        startLocation = nil
    }
}
        
class webViewViewController: UIViewController {
 
    //This is the class for the web view
    @IBOutlet var webViewEvent: WKWebView!
    
    override func viewDidLoad (){
        let myURL = URL(string:"https://pier36nyc.com/")
        let request = URLRequest(url: myURL!)
        webViewEvent.load(request)
        
    }
    
}
            
class PlayersViewController: UIViewController {
    // This class is just three buttons that open a url for the user to get more informaiton about who they are voting for.
    
    //Ended up using safariservices becuase i was having trouble with the way Messner was opening seperate URL's in his videos.
    @IBAction func joelEmbiid(_ sender: Any) {
        
        let url = URL(string: "https://www.nba.com/player/203954/joel-embiid")
        let vc = SFSafariViewController(url: url!)
        present(vc, animated: true, completion: nil)
        
    }
    
    
    @IBAction func giannisAnteto(_ sender: Any) {
        
        let url = URL(string: "https://www.nba.com/player/203507/giannis-antetokounmpo")
        let vc = SFSafariViewController(url: url!)
        present(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func nikolaJokic(_ sender: Any) {
        
        let url = URL(string: "https://www.nba.com/player/203999/nikola-jokic")
        let vc = SFSafariViewController(url: url!)
        present(vc, animated: true, completion: nil)
        
        
    }
    
}


class fileViewController: UIViewController {
    //This class is for a file write in to get data from the user
    
    @IBOutlet var firstName: UITextField!
    @IBOutlet var lastName: UITextField!
    @IBOutlet var Attendence: UITextField!
    @IBOutlet var results: UITextView!
    
    
    
    @IBAction func saveInformation(_ sender: Any) {
        let csvLine:String = "\(firstName.text!) \(lastName.text!), \(Attendence.text!)\n"
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let docDir:String = paths[0]
        let resultsFile:String = (docDir as NSString).appendingPathComponent("results.csv")
        
        if !FileManager.default.fileExists(atPath: resultsFile){
            FileManager.default.createFile(atPath: resultsFile, contents: nil, attributes: nil)
        }
        let fileHandle:FileHandle=FileHandle(forUpdatingAtPath: resultsFile)!
        fileHandle.seekToEndOfFile()
        fileHandle.write(csvLine.data(using: String.Encoding.utf8)!)
        fileHandle.closeFile()
        
        firstName.text = ""
        lastName.text = ""
        Attendence.text = ""
    }
    
    @IBAction func displayResults(_ sender: Any) {
        
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,FileManager.SearchPathDomainMask.userDomainMask, true)
        
        let docDir:String=paths[0] as String
        let resultsFile:String=(docDir as NSString).appendingPathComponent("results.csv")
        
        if FileManager.default.fileExists(atPath: resultsFile){
            let fileHandle:FileHandle = FileHandle(forReadingAtPath: resultsFile)!
            let resultsData:String!=NSString(data: fileHandle.availableData, encoding: String.Encoding.utf8.rawValue)! as String
            fileHandle.closeFile()
            
            results?.text=resultsData
        }
        }
    }
class voteViewController: UIViewController, MFMessageComposeViewControllerDelegate{
   
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
    }
    
 //this class contains the final vote. i made it so it sends an sms to the user to confirm the vote.
    
    
    @IBAction func joelEmbiid(_ sender: Any) {
        let SMS = MFMessageComposeViewController()
            SMS.messageComposeDelegate = self
            
            SMS.recipients = ["4846440238"]
            SMS.body = "I voted for Joel Embiid"
            
            if MFMessageComposeViewController.canSendText() {
                self.present(SMS, animated:true, completion:nil)
            }else{
                print("Cant send messages.")
            }
        
        
    }
    
    @IBAction func GA(_ sender: Any) {
        
        let SMS3 = MFMessageComposeViewController()
            SMS3.messageComposeDelegate = self
            
            SMS3.recipients = ["4846440238"]
            SMS3.body = "I voted for Giannis Antetokounmpo"
            
            if MFMessageComposeViewController.canSendText() {
                self.present(SMS3, animated:true, completion:nil)
            }else{
                print("Cant send messages.")
            }
        
        
    }
    
    @IBAction func Nikola(_ sender: Any) {
        
        let SMS2 = MFMessageComposeViewController()
            SMS2.messageComposeDelegate = self
            
            SMS2.recipients = ["4846440238"]
            SMS2.body = "I voted for Nikola Jokić"
            
            if MFMessageComposeViewController.canSendText() {
                self.present(SMS2, animated:true, completion:nil)
            }else{
                print("Cant send messages.")
            }
        
    }
}
    
    
    
    
    
    
    
    

    
    

        
