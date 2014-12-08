private
singleton
  "Don't persist instances of me"

  ^ SessionTemps current
    at: #'GemServerLauncher_Singleton'
    ifAbsent: [ SessionTemps current at: #'GemServerLauncher_Singleton' put: self new ]