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
    let mainMenu = "mainMenuAudio"
    let gameOver = "gameOverAudio"
    let game = "gameAudio"
    let victory = "victoryAudio"
    let button = "buttonClick"

    init() {}

    func playMainMenuAudio(isLooping: Bool = true) {
        play(fileName: mainMenu, isLooping: isLooping, player: &mainMenuAudioPlayer)
    }

    func playButtonClickAudio(isLooping: Bool = false) {
        play(fileName: button, isLooping: isLooping, player: &buttonClickAudioPlayer)
    }

    func playGameAudio(isLooping: Bool = false) {
        play(fileName: game, isLooping: isLooping, player: &mainMenuAudioPlayer)
    }

    func playVictoryAudio(isLooping: Bool = false) {
        play(fileName: victory, isLooping: isLooping, player: &mainMenuAudioPlayer)
    }

    func playGameOverAudio(isLooping: Bool = false) {
        play(fileName: gameOver, isLooping: isLooping, player: &mainMenuAudioPlayer)
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
