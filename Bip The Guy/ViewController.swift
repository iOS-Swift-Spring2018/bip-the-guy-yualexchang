//
//  ViewController.swift
//  Bip The Guy
//
//  Created by Yu Chang on 2/10/18.
//  Copyright © 2018 ISclass. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: IB Outlets
    @IBOutlet weak var imageToPunch: UIImageView!
    
    // MARK: variables
    var imagePicker = UIImagePickerController()
    var audioPlayer = AVAudioPlayer()
    var numOfSound = 5
    var soundIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: Functions
    func animateImage() {
        let bounds = self.imageToPunch.bounds
        let shrinkValue: CGFloat = 60
        
        //shrink the image to punch
        self.imageToPunch.bounds = CGRect(x: self.imageToPunch.bounds.origin.x + shrinkValue, y: self.imageToPunch.bounds.origin.y + shrinkValue, width: self.imageToPunch.bounds.size.width - shrinkValue, height: self.imageToPunch.bounds.size.height - shrinkValue)
        
        UIView.animate(withDuration: 0.25, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 10, options: [], animations: { self.imageToPunch.bounds = bounds }, completion: nil)
    }
    
    
    func playSound(soundName: String, audioPlayer: inout AVAudioPlayer) {
        if let sound = NSDataAsset(name: soundName) {
            //check to see if it is a sound file
            do {
                try audioPlayer = AVAudioPlayer(data: sound.data)
                audioPlayer.play()
            } catch {
                //if sound.data is not acceptable
                print("\(soundName) could not be played.")
            }
        } else {
            // if reading data didn't work, tell error
            print("\(soundName) didn't load.")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageToPunch.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func showAlert (title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }

    // MARK: Actions
    @IBAction func libraryPressed(_ sender: UIButton) {
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func cameraPressed(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            imagePicker.delegate = self
            present(imagePicker, animated: true, completion: nil)
        } else {
            showAlert(title: "Camera Not Available", message: "There is no camera available on this device.")
        }
        
    }
    
    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        soundIndex = Int(arc4random_uniform(UInt32(numOfSound)))
        animateImage()
        playSound(soundName: "punchSound\(soundIndex)", audioPlayer: &audioPlayer)
    }
    
}

