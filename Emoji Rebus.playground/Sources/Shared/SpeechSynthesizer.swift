import Foundation
import AppKit
import AVFoundation

protocol SpeechSynthesizerDelegate: AnyObject {
    func didFinish()
}

final class SpeechSynthesizer: NSObject {
    weak var speechSynthesizerDelegate: SpeechSynthesizerDelegate?
    private let voice: NSSpeechSynthesizer.VoiceName = {
        let filteredVoice = NSSpeechSynthesizer.availableVoices.filter { $0.rawValue.lowercased().contains("samantha") }.first
        return filteredVoice ?? NSSpeechSynthesizer.VoiceName(rawValue: "com.apple.speech.synthesis.voice.samantha")
    }()
    private lazy var synthesizer = NSSpeechSynthesizer(voice: voice) ?? NSSpeechSynthesizer()
    
    override init() {
        super.init()
        
        synthesizer.delegate = self
        synthesizer.rate = 250.0
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
    func speechSynthesizer(_ sender: NSSpeechSynthesizer, didFinishSpeaking finishedSpeaking: Bool) {
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
