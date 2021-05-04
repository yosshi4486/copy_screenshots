require 'fastlane/action'
require_relative '../helper/copy_screenshots_helper'

module Fastlane
  module Actions
    class CopyScreenshotsAction < Action
      def self.run(params)
        source_device_name = params[:source_device_name]
        target_device_name = params[:target_device_name]
        screenshots_dir_path = Actions.lane_context[SharedValues::SNAPSHOT_SCREENSHOTS_PATH]

        if screenshots_dir_path.nil?
          raise "Pre Action Required. This action should be executed after `capture_ios_screenshots` action."
        end

        # glob iterates files which matched to the given predicate.
        Dir.glob("#{screenshots_dir_path}/**/#{source_device_name}*.png") do |f|
          # gsub replaces and returns matched strings.
          copy_filepath = f.gsub(source_device_name, target_device_name)
          FileUtils.cp(f, copy_filepath)
          print("COPIED:".green)
          print("\"#{f}\"")
          print(" to ".green)
          puts("\"#{copy_filepath}\"")
        end
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Copy screenshots with a specified device name. This action should be executed after `capture_ios_screenshots` action."
      end

      def self.details
        "Main purpose of this action is copying screenshots for iPad Pro."
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :source_device_name,
                                       env_name: "SOURCE_DEVICE_NAME",
                                       description: "The source device name of copy",
                                       is_string: true,
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :target_device_name,
                                       env_name: "TARGET_DEVICE_NAME",
                                       description: "The target device name of copyone",
                                       is_string: true,
                                       optional: false)
        ]
      end

      def self.authors
        ["yosshi4486"]
      end

      def self.is_supported?(platform)
        [:ios, :mac].include?(platform)
      end

      def self.example_code
        [
          'copy_screenshots(
            source_device_name: "iPad Pro",
            target_device_name: "iPad Pro (12.9-inch) (3rd generation)"
          )'
        ]
      end

      def self.category
        :screenshots
      end
    end
  end
end
