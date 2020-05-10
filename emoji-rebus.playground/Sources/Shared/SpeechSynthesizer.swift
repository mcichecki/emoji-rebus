import Foundation
import AppKit
import AVFoundation

final class SpeechSynthesizer: NSObject {
    private let samanthaVoice = NSSpeechSynthesizer.VoiceName(rawValue: "com.apple.speech.synthesis.voice.samantha")
    private lazy var synthesizer = NSSpeechSynthesizer(voice: samanthaVoice) ?? NSSpeechSynthesizer()
    
    override init() {
        super.init()
        
        synthesizer.delegate = self
    }
    
    func speak(_ rebus: Rebus) {
        guard !synthesizer.isSpeaking else { return }
        synthesizer.startSpeaking(rebus.synthesizerDescription)
    }
    
    func stop() {
        synthesizer.stopSpeaking(at: .immediateBoundary)
    }
}

// MARK: - NSSpeechSynthesizerDelegate

extension SpeechSynthesizer: NSSpeechSynthesizerDelegate {
    func speechSynthesizer(_ sender: NSSpeechSynthesizer, willSpeakWord characterRange: NSRange, of string: String) {
        print("--- willSpeakWord: \(string)")
    }
    
    func speechSynthesizer(_ sender: NSSpeechSynthesizer, didFinishSpeaking finishedSpeaking: Bool) {
        print("--- didFinishSpeaking")
    }
}

// MARK: - Rebus Extension

private extension Rebus {
    var synthesizerDescription: String {
        if answer.title == "co2" { return "C O 2" }
        return answer.title
    }
}
