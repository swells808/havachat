//
//  VideoViewController.swift
//  havachat
//
//  Created by Sean Wells on 4/23/20.
//  Copyright © 2020 Sean Wells. All rights reserved.
//

import UIKit
import AgoraRtcKit
import Firebase
import FirebaseUI

class VideoViewController: UIViewController {
    
    let appID = "c231ca45d2294123aabc401497fd3e2f"
    var agoraKit: AgoraRtcEngineKit?
    var tempToken = ""
    var token: String? = ""
    var userID: UInt = 0
    var userName: String? = ""
    var remoteID: UInt = 0
    var channelName = ""
    var handle: AuthStateDidChangeListenerHandle?
    

    @IBOutlet weak var outsideVideoView: UIView!
    @IBOutlet weak var localVideoView: UIView!
    @IBOutlet weak var hangUpButton: UIButton!
    @IBOutlet weak var muteButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Agora video functions
        setUpVideo()
        joinChannel()
//        print(tempToken)
//        print(channelName)
//        print(userName)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        leaveChannel()
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    func setUserName(name: String?) {
        userName = name
        if let name = name {
            getAgoraEngine().registerLocalUserAccount(name, appId: appID)
        }
    }
    
    func setChannelName(channel: String) {
        channelName = channel
    }
    
    func setTokenName(token: String) {
        tempToken = token
    }
    
    // Agora video functions
    private func getAgoraEngine() -> AgoraRtcEngineKit {
        if agoraKit == nil {
            agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: appID, delegate: self)
        }
        
        return agoraKit!
    }
    
    func setUpVideo() {
        getAgoraEngine().enableVideo()
        
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = userID
        videoCanvas.view = localVideoView
        videoCanvas.renderMode = .fit
        getAgoraEngine().setupLocalVideo(videoCanvas)
        agoraKit?.setVideoEncoderConfiguration(AgoraVideoEncoderConfiguration(size: AgoraVideoDimension640x360,
        frameRate: .fps15,
        bitrate: AgoraVideoBitrateStandard,
        orientationMode: .adaptative))
    }
    
    func joinChannel() {
        localVideoView.isHidden = false
        print(tempToken)
        
        getAgoraEngine().joinChannel(byToken: tempToken, channelId: channelName, info: nil, uid: userID) { [weak self] (sid, uid, elapsed) in
            self?.userID = uid
        }
    }
    
    var muted = false {
        didSet {
            if muted {
                muteButton.setTitle("Unmute", for: .normal)
            } else {
                muteButton.setTitle("Mute", for: .normal)
            }
        }
    }
    
    @IBAction func didToggleMute(_ sender: UIButton) {
        sender.isSelected.toggle()
        if muted {
            getAgoraEngine().muteLocalAudioStream(false)
        } else {
            getAgoraEngine().muteLocalAudioStream(true)
        }
        muted = !muted
    }
    
    @IBAction func didTapHangUp(_ sender: UIButton) {
        sender.isSelected.toggle()
        leaveChannel()
    }
    
    func leaveChannel() {
        getAgoraEngine().leaveChannel(nil)
        localVideoView.isHidden = true
        self.dismiss(animated: true, completion: nil)
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension VideoViewController: AgoraRtcEngineDelegate {
    // first remote video frame
    func rtcEngine(_ engine: AgoraRtcEngineKit, firstRemoteVideoDecodedOfUid uid:UInt, size:CGSize, elapsed:Int) {
        
        // Only one remote video view is available for this
        // tutorial. Here we check if there exists a surface
        // view tagged as this uid.
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = uid
        videoCanvas.view = outsideVideoView
        videoCanvas.renderMode = .hidden
        agoraKit!.setupRemoteVideo(videoCanvas)
    }
    
}
