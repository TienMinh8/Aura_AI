import Foundation
import Speech
import AVFoundation
import SwiftUI

@Observable
final class SpeechService {
    static let shared = SpeechService()
    
    var isRecording: Bool = false
    var recognizedText: String = ""
    var audioLevel: CGFloat = 0.0
    var errorMessage: String? = nil
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "vi-VN")) ?? SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    private init() {}
    
    /// Request microphone and speech recognition permissions
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            DispatchQueue.main.async {
                switch authStatus {
                case .authorized:
                    AVAudioApplication.requestRecordPermission { granted in
                        DispatchQueue.main.async {
                            completion(granted)
                        }
                    }
                default:
                    completion(false)
                }
            }
        }
    }
    
    /// Start recording and live transcription
    func startRecording(onResult: @escaping (String) -> Void) {
        guard !audioEngine.isRunning else {
            stopRecording()
            return
        }
        
        requestAuthorization { [weak self] granted in
            guard let self = self, granted else {
                self?.errorMessage = "Vui lòng cấp quyền Micro & Nhận diện giọng nói trong Cài đặt."
                return
            }
            
            do {
                try self.beginAudioSessionAndRecognition(onResult: onResult)
            } catch {
                self.errorMessage = "Không thể khởi động micro: \(error.localizedDescription)"
                self.stopRecording()
            }
        }
    }
    
    private func beginAudioSessionAndRecognition(onResult: @escaping (String) -> Void) throws {
        // Cancel any active tasks
        recognitionTask?.cancel()
        recognitionTask = nil
        
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else {
            throw NSError(domain: "SpeechService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unable to create recognition request"])
        }
        
        recognitionRequest.shouldReportPartialResults = true
        if #available(iOS 13, *) {
            recognitionRequest.requiresOnDeviceRecognition = false
        }
        
        let inputNode = audioEngine.inputNode
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            guard let self = self else { return }
            
            if let result = result {
                let transcription = result.bestTranscription.formattedString
                DispatchQueue.main.async {
                    self.recognizedText = transcription
                    onResult(transcription)
                }
            }
            
            if error != nil || result?.isFinal == true {
                self.stopRecording()
            }
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.removeTap(onBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { [weak self] buffer, _ in
            self?.recognitionRequest?.append(buffer)
            
            // Calculate audio level for pulse animation
            let channelData = buffer.floatChannelData?[0]
            let frames = buffer.frameLength
            if let data = channelData, frames > 0 {
                var sum: Float = 0
                for i in 0..<Int(frames) {
                    sum += abs(data[i])
                }
                let avg = sum / Float(frames)
                let normalized = CGFloat(min(max(avg * 10, 0.1), 1.0))
                DispatchQueue.main.async {
                    self?.audioLevel = normalized
                }
            }
        }
        
        audioEngine.prepare()
        try audioEngine.start()
        
        DispatchQueue.main.async {
            self.isRecording = true
            self.recognizedText = ""
            self.errorMessage = nil
        }
    }
    
    /// Stop recording session
    func stopRecording() {
        guard isRecording || audioEngine.isRunning else { return }
        
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        recognitionRequest = nil
        recognitionTask?.cancel()
        recognitionTask = nil
        
        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        
        DispatchQueue.main.async {
            self.isRecording = false
            self.audioLevel = 0.0
        }
    }
}
