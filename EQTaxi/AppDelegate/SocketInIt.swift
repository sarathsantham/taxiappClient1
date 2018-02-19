//
//  SocketInIt.swift
//  EQTaxi
//
//  Created by Equator Technologies on 15/02/18.
//  Copyright © 2018 Equator Technologies. All rights reserved.
//

import Foundation
import SocketCluster_ios_client

var channel = SCChannel()

func GetconnectToserver(view : UIViewController){
        SCSocket .client()? .initWithHost(kSocketUrl, onPort: 3000, securely: true)
    SCSocket .client()? .delegate = view as! SocketClusterDelegate
        SCSocket .client()? .setRestoreChannels(true)
        SCSocket .client()? .connect()
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0, execute: {
           // connectchannel()
        })
    channel = SCChannel .init(channelName: "liveTracking", andDelegate: nil)
    channel.delegate = view as! SCChannelDelegate
    channel .subscribe(success: { (response) in
        
    }) { (error, response) in
        
    }
    }


