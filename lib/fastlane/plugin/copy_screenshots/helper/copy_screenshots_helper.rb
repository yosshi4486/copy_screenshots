require 'fastlane_core/ui/ui'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?("UI")

  module Helper
    class CopyScreenshotsHelper
      # class methods that you define here become available in your action
      # as `Helper::CopyScreenshotsHelper.your_method`
      #
      def self.show_message
        UI.message("Hello from the copy_screenshots plugin helper!")
      end
    end
  end
end
