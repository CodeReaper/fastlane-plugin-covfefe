module Fastlane
  module Helper
    class CovfefeHelper
      # class methods that you define here become available in your action
      # as `Helper::CovfefeHelper.your_method`
      #
      def self.show_message
        UI.message("Hello from the covfefe plugin helper!")
      end
    end
  end
end
