//
//  CallkitIncomingAppDelegate.swift
//  flutter_callkit_incoming
//  Created by Hoorad Ramezani on 05/01/2024.

import Foundation
import AVFAudio
import CallKit


public protocol CallkitIncomingAppDelegate : NSObjectProtocol {
    
    func onAccept(_ call: Call, _ action: CXAnswerCallAction);
    
    func onDecline(_ call: Call);
    
    func onEnd(_ call: Call);
    
    func onTimeOut(_ call: Call);

    func didActivateAudioSession(_ audioSession: AVAudioSession)
    
    func didDeactivateAudioSession(_ audioSession: AVAudioSession)
    
}
