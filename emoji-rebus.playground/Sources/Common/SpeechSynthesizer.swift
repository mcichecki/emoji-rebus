import Foundation
import AVFoundation

final class SpeechSynthesizer: NSObject {
    private let synthesizer = AVSpeechSynthesizer()
    
//    private var isSpeaking = false
    
    override init() {
        super.init()
        
        synthesizer.delegate = self
    }
    
    deinit {
        print("--- SpeechSynthesizer deinit")
    }
    
    func speak(_ rebus: Rebus) {
        guard !synthesizer.isSpeaking else { return }
        print("--- \(!synthesizer.isSpeaking) | \(rebus.synthesizerDescription) | \(self)")
        
        let speechUtterance = AVSpeechUtterance(string: rebus.synthesizerDescription)
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en")
        speechUtterance.rate = 0.3
        print("--- utterance: \(speechUtterance)")
        synthesizer.speak(speechUtterance)
    }
    
    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
    }
}

// MARK: - AVSpeechSynthesizerDelegate

extension SpeechSynthesizer: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        print("--- didStart")
//        isSpeaking = true
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        print("--- didFinish")
//        isSpeaking = false
    }
}

// MARK: - Rebus Extension

private extension Rebus {
    var synthesizerDescription: String {
        return answer.title
    }
}
