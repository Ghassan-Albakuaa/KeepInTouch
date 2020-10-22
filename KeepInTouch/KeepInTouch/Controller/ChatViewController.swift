//
//  ChatViewController.swift
//  KeepInTouch
//
//  Created by Ghassan  albakuaa  on 10/18/20.
//
import UIKit
import Firebase
class ChatViewController: UIViewController {

   @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    let db = Firestore.firestore()
    
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        navigationItem.hidesBackButton = true
        title = K.appName
        
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        loadMessages()
    }
    
    func loadMessages() {
        
        
       // db.collection(K.FStore.collectionName).getDocuments { (querySnapshot , error ) in
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener { (querySnapshot , error ) in
            self.messages = []
            if let e = error {
                print("there was problem withn retreving data from firestore \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                  for doc in snapshotDocuments {
                                   //  print(doc.data())
                  let data = doc.data()
                   if let messageSender = data[K.FStore.senderField] as? String, let messageBody = data[K.FStore.bodyField] as? String {
                       let newMassage = Message(sender: messageSender, body: messageBody)
                    self.messages.append(newMassage)
                 
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        let index = IndexPath(row: self.messages.count - 1, section: 0)
                        self.tableView.scrollToRow(at: index, at: .top , animated: true)
                    }
                   
                        }
                        
                    }
                }
            }
        }
    }
    
   @IBAction func sendPressed(_ sender: UIButton) {
    
   if let messageBody = messageTextfield.text , let messageSender = Auth.auth().currentUser?.email
   {
    db.collection(K.FStore.collectionName).addDocument(data: [K.FStore.senderField: messageSender , K.FStore.bodyField: messageBody ,K.FStore.dateField: Date().timeIntervalSince1970 ])  { (error) in
        if let e = error {
            print("there is error with saving in firestore \(e)")
        } else {
        print("successfuly saved data")
            DispatchQueue.main.async {
                self.messageTextfield.text = ""
            }
           
        }
        
    }
   }
    
   }
    
    @IBAction func LogOutPressed(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
       do {
         try firebaseAuth.signOut()
        navigationController?.popToRootViewController(animated: true)
       } catch let signOutError as NSError {
         print ("Error signing out: %@", signOutError)
       }    }
    
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = messages[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier , for: indexPath) as! MessageCell
        cell.label.text = messages[indexPath.row].body
      //  cell.labelTwo.text = message.sender
        var name = message.sender.prefix(2)
        
        //this message from current user
        if message.sender == Auth.auth().currentUser?.email {
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lighBlue)
            cell.label.textColor = .black
            cell.labelTwo.isHidden = true
            
        }
        //other
        else {
            cell.labelTwo.text = "\(name)"
            cell.labelTwo.isHidden = false
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            cell.label.textColor = .black       }
        
        
        return cell
        
    }
}

extension ChatViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // print(indexPath.row)
    }
}
