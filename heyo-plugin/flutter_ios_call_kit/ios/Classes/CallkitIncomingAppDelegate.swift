//
//  CallkitIncomingAppDelegate.swift
//  flutter_ios_call_kit
//  Created by Hoorad Ramezani on 5/01/2024.

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
