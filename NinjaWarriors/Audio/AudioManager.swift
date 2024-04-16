//
//  AudioManager.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 9/4/24.
//

import Foundation
import AVFoundation

class AudioManager: ObservableObject {
    static let shared = AudioManager()

    var audioPlayer: AVAudioPlayer?
    var mainMenuAudioPlayer: AVAudioPlayer?
    var buttonClickAudioPlayer: AVAudioPlayer?
    var isPlaying = false
    var isLooping = false

    let mainMenu = "mainMenu"
    let gameOver = "gameOver"
    let victory = "victory"
    let button = "click"
    let slash = "slash"
    let dash = "dash"
    let refresh = "refresh"
    let shield = "shield"
    let whoosh = "whoosh"

    init() {}

    func playMainMenuAudio(isLooping: Bool = true) {
        play(fileName: mainMenu, isLooping: isLooping, player: &mainMenuAudioPlayer)
    }

    func playGameOverAudio(isLooping: Bool = false) {
        play(fileName: gameOver, isLooping: isLooping, player: &mainMenuAudioPlayer)
    }

    func playVictoryAudio(isLooping: Bool = false) {
        play(fileName: victory, isLooping: isLooping, player: &mainMenuAudioPlayer)
    }

    func playButtonClickAudio(isLooping: Bool = false) {
        play(fileName: button, isLooping: isLooping, player: &buttonClickAudioPlayer)
    }

    func playSkillAudio(for skill: String) {
        play(fileName: skill, isLooping: false, player: &buttonClickAudioPlayer)
    }

    func playSlashAudio(isLooping: Bool = false) {
        play(fileName: slash, isLooping: isLooping, player: &mainMenuAudioPlayer)
    }

    func playDashAudio(isLooping: Bool = false) {
        play(fileName: dash, isLooping: isLooping, player: &mainMenuAudioPlayer)
    }

    func playRefreshAudio(isLooping: Bool = false) {
        play(fileName: refresh, isLooping: isLooping, player: &mainMenuAudioPlayer)
    }

    func playShieldAudio(isLooping: Bool = false) {
        play(fileName: shield, isLooping: isLooping, player: &mainMenuAudioPlayer)
    }

    func playWhooshAudio(isLooping: Bool = false) {
        play(fileName: whoosh, isLooping: isLooping, player: &mainMenuAudioPlayer)
    }

    private func play(fileName: String, isLooping: Bool, player: inout AVAudioPlayer?) {
        guard let soundURL = Bundle.main.url(forResource: fileName, withExtension: "mp3") else {
            return
        }
        do {
            player = try AVAudioPlayer(contentsOf: soundURL)
            player?.numberOfLoops = isLooping ? -1 : 0
            player?.play()
        } catch {
            print("Error loading sound file: \(error.localizedDescription)")
        }
    }

    func pause() {
        audioPlayer?.pause()
        isPlaying = false
    }

    func stop() {
        audioPlayer?.stop()
        audioPlayer?.currentTime = 0
        isPlaying = false
    }

    func stopAll() {
        mainMenuAudioPlayer?.stop()
        buttonClickAudioPlayer?.stop()
    }
}
