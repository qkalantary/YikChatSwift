import UIKit
import MultipeerConnectivity

class ViewController: UIViewController, MCBrowserViewControllerDelegate,
MCSessionDelegate,UITextFieldDelegate {
    

    
    var browser : MCBrowserViewController!
    var assistant : MCAdvertiserAssistant!
    var session : MCSession!
    let serviceType = "yik-chat"
    
    @IBOutlet var chatView: UITextView!
    @IBOutlet var messageField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("messaging")
        messageField.delegate = self

        self.session = MCSession(peer: global.peerID)
        self.session.delegate = self
        
        self.browser = MCBrowserViewController(serviceType:serviceType,
            session:self.session)
        
        self.browser.delegate = self;
        
        //initialize assistant
        self.assistant = MCAdvertiserAssistant(serviceType:serviceType,
            discoveryInfo:nil, session:self.session)
        
        self.assistant.start()
    }
    
    @IBAction func sendChat(sender: UIButton) {
        // Bundle up the text in the message field, and send it off to all
        // connected peers
        
        let msg = (global.peerID.displayName + ": " + self.messageField.text + "\n").dataUsingEncoding(NSUTF8StringEncoding,
            allowLossyConversion: false)
        
        var error : NSError?
        println(global.peerID.displayName)
        self.session.sendData(msg, toPeers: self.session.connectedPeers,
            withMode: MCSessionSendDataMode.Reliable, error: &error)
        
        //if error != nil {
        //    print("Error sending data: \(error?.localizedDescription)")
        //}
        
        self.updateChat("Me" + ": " + self.messageField.text + "\n", fromPeer: global.peerID)
        
        self.messageField.text = ""
    }
    
    func updateChat(text : String, fromPeer peerID: MCPeerID) {
        var name : String
        
        if (peerID == global.peerID) {
            name = "Me"
        } else {
            name = peerID.displayName
            println(peerID.displayName)
        }
    
    
        // Add the name to the message and display it
        //let message = "\(name): \(text)\n"
        self.chatView.text = self.chatView.text + text
        //[TextView scrollRangeToVisible:NSMakeRange([TextView.text length], 0)];
       // chatView.scrollRangeToVisible(0, chatView.text)
        
    }
    
    @IBAction func showBrowser(sender: UIButton) {
        // Show the browser view controller
        self.presentViewController(self.browser, animated: true, completion: nil)
    }
    
    func browserViewControllerDidFinish(
        browserViewController: MCBrowserViewController!)  {
            // Called when the browser view controller is dismissed
            connection()
            self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func connection()  {
            // Called when the browser view controller is dismissed
        let message = "Someone has joined the YikChat!\n"
        self.chatView.text = self.chatView.text + message

    }
    
    func browserViewControllerWasCancelled(
        browserViewController: MCBrowserViewController!)  {
            // Called when the browser view controller is cancelled
            
            self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func session(session: MCSession!, didReceiveData data: NSData!,
        fromPeer peerID: MCPeerID!)  {
            // Called when a peer sends an NSData to us
            
            // This needs to run on the main queue
            dispatch_async(dispatch_get_main_queue()) {
                
                var msg = NSString(data: data, encoding: NSUTF8StringEncoding)
                
                self.updateChat(msg!, fromPeer: peerID)
            }
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        self.view.endEditing(true);
        return false;
    }
    
    // The following methods do nothing, but the MCSessionDelegate protocol
    // requires that we implement them.
    func session(session: MCSession!,
        didStartReceivingResourceWithName resourceName: String!,
        fromPeer peerID: MCPeerID!, withProgress progress: NSProgress!)  {
            
            // Called when a peer starts sending a file to us
    }
    
    func session(session: MCSession!,
        didFinishReceivingResourceWithName resourceName: String!,
        fromPeer peerID: MCPeerID!,
        atURL localURL: NSURL!, withError error: NSError!)  {
            // Called when a file has finished transferring from another peer
    }
    
    func session(session: MCSession!, didReceiveStream stream: NSInputStream!,
        withName streamName: String!, fromPeer peerID: MCPeerID!)  {
            // Called when a peer establishes a stream with us
    }
    
    func session(session: MCSession!, peer peerID: MCPeerID!,
        didChangeState state: MCSessionState)  {
            // Called when a connected peer changes state (for example, goes offline)
            
    }
    
}

