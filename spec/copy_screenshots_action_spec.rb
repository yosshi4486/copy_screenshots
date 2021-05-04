require 'fileutils'
require 'fastlane/action'

describe Fastlane::Actions::CopyScreenshotsAction do
  describe '#run' do
    base_path = __dir__
    original_images_dir_path = File.join(base_path, "original_images")
    test_images_dir_path = File.join(base_path, "test_images")
    enus_test_filepath = File.join(test_images_dir_path, ["en-US", ["iPad\ Pro\ \(12.9-inch\)\ \(3rd\ generation\)-Test.png"]])
    ja_test_filepath = File.join(test_images_dir_path, ["ja", ["iPad\ Pro\ \(12.9-inch\)\ \(3rd\ generation\)-Test.png"]])

    before do
      FileUtils.cp_r(original_images_dir_path, test_images_dir_path)
    end

    it 'iPad Pro (12.9-inch) (2nd generation) screenshots are copied as iPad Pro (12.9-inch) (3rd generation)' do
      Fastlane::Actions.lane_context[Fastlane::Actions::SharedValues::SNAPSHOT_SCREENSHOTS_PATH] = test_images_dir_path

      expect(File.exist?(enus_test_filepath)).to be_falsey
      expect(File.exist?(ja_test_filepath)).to be_falsey

      Fastlane::FastFile.new.parse("lane :test do
        copy_screenshots(
          source_device_name:\"iPad Pro (12.9-inch) (2nd generation)\",
          target_device_name:\"iPad Pro (12.9-inch) (3rd generation)\"
        )
      end").runner.execute(:test)

      expect(File.exist?(enus_test_filepath)).to be_truthy
      expect(File.exist?(ja_test_filepath)).to be_truthy

      Fastlane::Actions.lane_context[Fastlane::Actions::SharedValues::SNAPSHOT_SCREENSHOTS_PATH] = nil
    end

    it 'Raise error when `capture_ios_screenshots` is not executed' do

      Fastlane::Actions.lane_context[Fastlane::Actions::SharedValues::SNAPSHOT_SCREENSHOTS_PATH] = nil

      expect(File.exist?(enus_test_filepath)).to be_falsey
      expect(File.exist?(ja_test_filepath)).to be_falsey

      runner = Fastlane::FastFile.new.parse("lane :test do
        copy_screenshots(
          source_device_name:\"iPad Pro (12.9-inch) (2nd generation)\",
          target_device_name:\"iPad Pro (12.9-inch) (3rd generation)\"
        )
      end").runner

      error_text = <<-EOS
      Description:
      Pre Action Required

      Reason:
      This action should be executed after `capture_ios_screenshots` action. 

      Recover:
      Please add the action like belows:

        capture_ios_screenshots(
          skip_open_summary: true,
          clean: true
        )
      
        copy_screenshots(
          source_device_name: \"iPad Pro (12.9-inch) (2nd generation)\",
          target_device_name: \"iPad Pro (12.9-inch) (3rd generation)\"
        )
        
      EOS

      expect { runner.execute(:test) }.to raise_error(error_text)
      
    end

    after do
      FileUtils.rm_r(test_images_dir_path, { force: true })
    end
  end
end
