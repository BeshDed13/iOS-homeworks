//
//  LocalAuthorizationService.swift
//  Navigation
//
//  Created by Дмитрий Ильинский on 11.03.2026.
//

import LocalAuthentication

final class LocalAuthorizationService {
    
    func authorizeIfPossible(_ authorizationFinished: @escaping (Bool) -> Void) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Authorize to access your data"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, evaluationError in
                DispatchQueue.main.async {
                    authorizationFinished(success)
                }
            }
        } else {
            DispatchQueue.main.async {
                authorizationFinished(false)
            }
        }
    }
}
