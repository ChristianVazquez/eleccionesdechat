//
//  ViewController.swift
//  Elections
//
//  Created by LABMAC05 on 26/04/19.
//  Copyright © 2019 utng.christian. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = myList[indexPath.row]
        return cell
    }
    

    var ref = DatabaseReference.init()
    
    @IBOutlet weak var idtext: UITextField!
    @IBOutlet weak var txtCandText: UITextField!
    @IBOutlet weak var txtPersonText: UITextField!
    
    @IBOutlet weak var myTabla: UITableView!
    
    var myList:[String] = []
    var handle:DatabaseHandle?
    //var ref :DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loginAnony()
        self.ref = Database.database().reference()
        listar()
        
    }
    
    
    

    func loginAnony()
    {
        Auth.auth().signInAnonymously()
        {
            (user, error) in
            
            if let error = error
            {
                print ("Cannot login: \(error)")
            }else
            {
                print ("user UID \(String(describing: user?.user))")
                
            }
        }
    }
    
    
    @IBAction func buSendToRoom(_ sender: Any) {
        let dic = ["ID" : idtext.text!,"Nombre" : txtPersonText.text!,
                   "Candidato" : txtCandText.text!
                   ]
        self.ref.child("user").child(idtext.text!).setValue(dic)
        idtext.text! = ""
        txtPersonText.text! = ""
        txtCandText.text = ""
        
    }

    @IBAction func actualizar(_ sender: Any) {
        
        
        self.ref.child("user").child(idtext.text!).setValue(["ID" : idtext.text!,"Nombre" : txtPersonText.text!,
            "Candidato" : txtCandText.text!])
        idtext.text! = ""
        txtPersonText.text! = ""
        txtCandText.text = ""
        listar()
        
    }
    @IBAction func borrar(_ sender: Any) {
        
        self.ref.child("user").child(idtext.text!).removeValue()
        idtext.text! = ""
        txtPersonText.text! = ""
        txtCandText.text = ""
        listar()
    }

    @IBAction func mostrar(_ sender: Any) {
        handle = self.ref.child("user").observe(.childAdded, with: { (snapshot) in
            print(snapshot.value ?? "No item")
            if let item = snapshot.value as? [String : String]{
                
                
                self.myList.append(" \(item["ID"]!) \(item["Candidato"]!)")
                self.myTabla.reloadData()
                
                
            }
            
        })
        
    }
    
    func listar() {
        myList.removeAll()
        handle = self.ref.child("user").observe(.childAdded, with: { (snapshot) in
            print(snapshot.value ?? "No item")
            if let item = snapshot.value as? [String : String]{
                
                
                self.myList.append(" \(item["ID"]!) \(item["Candidato"]!)")
                self.myTabla.reloadData()
                
                
            }
            
        })
        
    }
    
    }
