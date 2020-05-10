import Foundation
import AppKit
import AVFoundation

protocol SpeechSynthesizerDelegate: AnyObject {
    func didFinish()
}

final class SpeechSynthesizer: NSObject {
    weak var speechSynthesizerDelegate: SpeechSynthesizerDelegate?
    
    private let samanthaVoice = NSSpeechSynthesizer.VoiceName(rawValue: "com.apple.speech.synthesis.voice.samantha")
    private lazy var synthesizer = NSSpeechSynthesizer(voice: samanthaVoice) ?? NSSpeechSynthesizer()
    
    override init() {
        super.init()
        
        synthesizer.delegate = self
        synthesizer.rate = 220.0
    }
    
    func speak(_ rebus: Rebus) {
        guard !synthesizer.isSpeaking else { return }
        synthesizer.startSpeaking(rebus.synthesizerDescription)
    }
    
    func speak(_ answer: Answer) {
        if synthesizer.isSpeaking {
            stop()
        }

        synthesizer.startSpeaking(answer.description)
    }
    
    func speak(text: String) {
        let trimmed = text.withoutSpecialCharacters
        synthesizer.startSpeaking(trimmed)
    }
    
    func stop() {
        synthesizer.stopSpeaking(at: .wordBoundary)
    }
}

// MARK: - NSSpeechSynthesizerDelegate

extension SpeechSynthesizer: NSSpeechSynthesizerDelegate {
//    func speechSynthesizer(_ sender: NSSpeechSynthesizer, willSpeakWord characterRange: NSRange, of string: String) {
//        print("--- willSpeakWord in range: \(characterRange)")
//    }
    
    func speechSynthesizer(_ sender: NSSpeechSynthesizer, didFinishSpeaking finishedSpeaking: Bool) {
        print("--- didFinishSpeaking")
        speechSynthesizerDelegate?.didFinish()
    }
}

// MARK: - Rebus Extension

private extension Rebus {
    var synthesizerDescription: String {
        if answer.title == "co2" { return "C O 2" }
        return answer.title
    }
}

// MARK: - String Extension

private extension String {
    var withoutSpecialCharacters: String {
        components(separatedBy: CharacterSet.symbols).joined(separator: "-")
    }
}
