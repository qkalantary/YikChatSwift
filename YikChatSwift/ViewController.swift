import UIKit
import MultipeerConnectivity

class ViewController: UIViewController, MCBrowserViewControllerDelegate,
MCSessionDelegate,UITextFieldDelegate {
    
    //let text_logo = UIImage(named: "YikChatTextLogo.jpg")
    //let imageview = UIImageView(image: text_logo)
    //self.view.addSubview(imageview)
    
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
        
        self.browser.delegate = self
        
        self.assistant = MCAdvertiserAssistant(serviceType:serviceType,
            discoveryInfo:nil, session:self.session)
        
        self.assistant.start()
    }
    
    @IBAction func sendChat(sender: UIButton) {
        let msg = (global.peerID.displayName + ": " + self.messageField.text + "\n").dataUsingEncoding(NSUTF8StringEncoding,
            allowLossyConversion: false)
        
        var error : NSError?
        
        self.session.sendData(msg, toPeers: self.session.connectedPeers,
            withMode: MCSessionSendDataMode.Reliable, error: &error)
        
        if (self.messageField.text != "") {
            self.updateChat("Me" + ": " + self.messageField.text + "\n", fromPeer: global.peerID)
        }
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
       // [textView scrollRangeToVisible:NSMakeRange([textView.text length], 0)];
        chatView.scrollRangeToVisible(NSMakeRange(chatView.text.utf16Count, chatView.text.utf16Count))
        
    }
    
    @IBAction func showBrowser(sender: UIButton) {
        self.presentViewController(self.browser, animated: true, completion: nil)
    }
    
    func browserViewControllerDidFinish(
        browserViewController: MCBrowserViewController!)  {
            connection()
            self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func connection()  {
        let message = "someone has joined the YikChat!\n"
        self.chatView.text = self.chatView.text + message

    }
    
    func browserViewControllerWasCancelled(
        browserViewController: MCBrowserViewController!)  {
            
            self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func session(session: MCSession!, didReceiveData data: NSData!,
        fromPeer peerID: MCPeerID!)  {
            
            dispatch_async(dispatch_get_main_queue()) {
                
                var msg = NSString(data: data, encoding: NSUTF8StringEncoding)
                
                self.updateChat(msg!, fromPeer: peerID)
            }
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        self.view.endEditing(true);
        let msg = (global.peerID.displayName + ": " + self.messageField.text + "\n").dataUsingEncoding(NSUTF8StringEncoding,
            allowLossyConversion: false)
        
        var error : NSError?
        
        self.session.sendData(msg, toPeers: self.session.connectedPeers,
            withMode: MCSessionSendDataMode.Reliable, error: &error)
        
        if (self.messageField.text != "") {
            self.updateChat("Me" + ": " + self.messageField.text + "\n", fromPeer: global.peerID)
        }
        self.messageField.text = ""
        
        //textField.becomeFirstResponder()
        return false;
    }
    
    
    func session(session: MCSession!,
        didStartReceivingResourceWithName resourceName: String!,
        fromPeer peerID: MCPeerID!, withProgress progress: NSProgress!)  {
            
    }
    
    func session(session: MCSession!,
        didFinishReceivingResourceWithName resourceName: String!,
        fromPeer peerID: MCPeerID!,
        atURL localURL: NSURL!, withError error: NSError!)  {
    }
    
    func session(session: MCSession!, didReceiveStream stream: NSInputStream!,
        withName streamName: String!, fromPeer peerID: MCPeerID!)  {
    }
    
    func session(session: MCSession!, peer peerID: MCPeerID!,
        didChangeState state: MCSessionState)  {
            
    }
    
}

