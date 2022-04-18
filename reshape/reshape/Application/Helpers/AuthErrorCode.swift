//
//  AuthErrorCode.swift
//  reshape
//
//  Created by Veronika on 15.04.2022.
//

import Foundation
import FirebaseAuth

extension AuthErrorCode {
    var errorMessage: String {
        switch self {
        case .emailAlreadyInUse:
            return "Эта почта уже используется другим пользователем."
        case .userNotFound:
            return "Аккаунт не найден. Пожалуйста, проверьте данные и попробуйте еще раз."
        case .userDisabled:
            return "Ваш аккаунт заблокирован. Пожалуйста, обратитесь в поддержку."
        case .invalidEmail, .invalidSender, .invalidRecipientEmail:
            return "Пожалуйста введите корректную почту."
        case .networkError:
            return "Нет сети. Пожалуйста, проверьте наличие сети и попробуйте еще раз."
        case .weakPassword:
            return "Пароль слишком слабый. Пожалуйста, введите минимум 6 символов."
        case .wrongPassword:
            return "Неверный пароль. Пожалуйста, введите еще раз или восстановите его."
        default:
            return "Неизвестная ошибка..."
        }
    }
}
