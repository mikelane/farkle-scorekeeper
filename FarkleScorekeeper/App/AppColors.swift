import SwiftUI

enum AppColors {
    // MARK: - Button Colors

    enum Button {
        static var enabledBackground: Color {
            Color("ButtonEnabled", bundle: nil)
        }

        static var disabledBackground: Color {
            Color("ButtonDisabled", bundle: nil)
        }

        static var enabledForeground: Color {
            .white
        }

        static var disabledForeground: Color {
            Color.secondary
        }

        static var farkleBackground: Color {
            Color("FarkleButton", bundle: nil)
        }

        static var bankEnabledBackground: Color {
            Color("BankEnabled", bundle: nil)
        }

        static var bankDisabledBackground: Color {
            Color.gray
        }
    }

    // MARK: - Score Colors

    enum Score {
        static var turnScore: Color {
            Color("TurnScore", bundle: nil)
        }

        static var canBank: Color {
            Color("CanBank", bundle: nil)
        }

        static var mustRoll: Color {
            Color("MustRoll", bundle: nil)
        }
    }

    // MARK: - Game Over Colors

    enum GameOver {
        static var overlayBackground: Color {
            Color.black.opacity(0.7)
        }

        static var winnerHighlight: Color {
            Color.yellow
        }
    }

    // MARK: - High Contrast Variants

    enum HighContrast {
        static var borderColor: Color {
            Color.primary
        }

        static var borderWidth: CGFloat {
            2
        }
    }
}

// MARK: - Convenience Extensions

extension Color {
    static var buttonEnabled: Color { AppColors.Button.enabledBackground }
    static var buttonDisabled: Color { AppColors.Button.disabledBackground }
    static var farkleButton: Color { AppColors.Button.farkleBackground }
    static var bankEnabled: Color { AppColors.Button.bankEnabledBackground }
    static var turnScore: Color { AppColors.Score.turnScore }
    static var canBank: Color { AppColors.Score.canBank }
    static var mustRoll: Color { AppColors.Score.mustRoll }
}
