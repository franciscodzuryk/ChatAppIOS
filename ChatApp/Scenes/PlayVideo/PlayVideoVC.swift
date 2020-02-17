//
//  PlayVideoVC.swift
//  ChatApp
//
//  Created by Luis Francisco Dzuryk on 18/06/2019.
//  Copyright © 2019 Luis Francisco Dzuryk. All rights reserved.
//

import UIKit
import AVFoundation
import youtube_ios_player_helper_swift

protocol PlayVideoInterface: class {
    func showStatus(status: CompanyStatus)
}

class PlayVideoVC: UIViewController {
    
    @IBOutlet private weak var playerView: YTPlayerView!
    @IBOutlet private weak var loadingMovieIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var btnPlayPause: UIButton!
    private var ctrler: PlayVideoCtrl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ctrler = PlayVideoCtrl(self, apiClient: LocalStorage.isDemoMode() ? APIUserDemo() : APIUserClient())
        loadVideo(videoId: "2kmUfWPeIRE")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ctrler.startPolling()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ctrler.stopPolling()
        playerView.stopVideo()
    }
    
    func loadVideo(videoId:String) {
        let playerVars:[String: Any] = [
            "controls" : "0",
            "showinfo" : "0",
            "autoplay": "0",
            "rel": "0",
            "modestbranding": "0",
            "iv_load_policy" : "3",
            "fs": "0",
            "playsinline" : "1"
        ]
        playerView.delegate = self
        _ = playerView.load(videoId: videoId, playerVars: playerVars)
        playerView.isUserInteractionEnabled = false
    }
    
    @IBAction func playPause(_ sender: Any) {
        if playerView.playerState == .playing {
            playerView.pauseVideo()
            btnPlayPause.backgroundColor = #colorLiteral(red: 0.370555222, green: 0.3705646992, blue: 0.3705595732, alpha: 0.5104880137)
            btnPlayPause.setImage(UIImage(named:"play_icon"), for:.normal)
        } else {
            playerView.playVideo()
            btnPlayPause.backgroundColor = UIColor.clear
            btnPlayPause.setImage(nil, for:.normal)
        }
    }
    
}

extension PlayVideoVC: YTPlayerViewDelegate, PlayVideoInterface {
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView){
        loadingMovieIndicator.stopAnimating()
        playerView.playVideo()
        btnPlayPause.backgroundColor = UIColor.clear
        btnPlayPause.setImage(nil, for:.normal)
    }
    
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState){
        
    }
    
    func playerView(_ playerView: YTPlayerView, didChangeTo quality: YTPlaybackQuality){
        
    }
    
    func playerView(_ playerView: YTPlayerView, receivedError error: YTPlayerError) {
        print(error)
    }
    
    func playerView(_ playerView: YTPlayerView, didPlayTime playTime: Float){
        
    }
    
    func playerViewPreferredWebViewBackgroundColor(_ playerView: YTPlayerView) -> UIColor{
        return UIColor.black
    }
    
    func playerViewPreferredInitialLoadingView(_ playerView: YTPlayerView) -> UIView?{
        return UIImageView(image:UIImage(named:"video_not_found"))
    }
    
    func showStatus(status: CompanyStatus) {
        if status == .active {
            self.navigationController?.popViewController(animated: true)
            playerView.stopVideo()
        }
    }
}

class PlayVideoCtrl {
    private weak var view: PlayVideoInterface!
    private let apiClient: APIUserClientInterface
    private var timer: DispatchSourceTimer?
    
    init(_ view: PlayVideoInterface, apiClient: APIUserClientInterface) {
        self.view = view
        self.apiClient = apiClient
    }
    
    func startPolling() {
        let queue = DispatchQueue.global(qos: .background)
        timer = DispatchSource.makeTimerSource(queue: queue) as DispatchSourceTimer
        timer?.schedule(deadline: .now(), repeating: .seconds(10), leeway: .seconds(2))
        timer?.setEventHandler(handler: { [weak self] in
            guard let self = self else {
                return
            }
            self.apiClient.getStatus(success: { (company) in
                self.view.showStatus(status: company.status)
            }, fail: { (error) in
            })
        })
        timer?.resume()
    }
    
    func stopPolling() {
        timer?.cancel()
        timer = nil
    }

}
