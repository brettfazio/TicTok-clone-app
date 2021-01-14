//
//  audioTestViewController.swift
//  TIK TIK
//
//  Created by Junaid  Kamoka on 24/08/2020.
//  Copyright © 2020 Junaid Kamoka. All rights reserved.
//

import UIKit
import AVFoundation

class audioTestViewController: UIViewController {
    var audioPlayer : AVAudioPlayer?

      override func viewDidLoad() {
          super.viewDidLoad()
          
                          if let url = UserDefaults.standard.string(forKey: "url"), let audioUrl = URL(string: url) {
                              
                              // then lets create your document folder url
                              let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                              
                              // lets create your destination file url
                              let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
                              
                              print("destinationUrl: ",destinationUrl)
                              //let url = Bundle.main.url(forResource: destinationUrl, withExtension: "mp3")!
                              
          //                    MARKED:- NEWAUDIO
          //                    let playerItem = AVPlayerItem( url:destinationUrl)
          //                    audioPlayer = AVPlayer(playerItem:playerItem)
                              audioPlayer?.rate = 1.0;
                              
          //                    let path = Bundle.main.path(forResource: "\(destinationUrl)", ofType:nil)!
          //                    let url = URL(fileURLWithPath: path)

                              do {
                                  audioPlayer = try AVAudioPlayer(contentsOf: destinationUrl)
//                                  audioPlayer?.play()
                              } catch {
                                  // couldn't load file :(
                                  print("CouldNot load audio file")
                              }
                  //            if (playerItem.asset.duration != nil){
                  //            let duration : CMTime = playerItem.asset.duration
                  //            let seconds : Float64 = CMTimeGetSeconds(duration)
                  //            self.progressView.setProgress(Float(seconds), animated: true)
                  //
                  //            self.progressView.alpha = 1
                  //            }
                              
          //                    audioPlayer?.play()
                          }
          // Do any additional setup after loading the view.
      }

      @IBAction func btnPlay(_ sender: Any) {
          
          audioPlayer?.play()
      }
      
      @IBAction func btnPause(_ sender: Any) {
          audioPlayer?.pause()
      }
      
      @IBAction func btnStop(_ sender: Any) {
          audioPlayer?.stop()
      }

}
