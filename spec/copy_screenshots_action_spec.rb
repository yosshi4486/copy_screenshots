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
      Fastlane::Actions.lane_context[Fastlane::Actions::SharedValues::SNAPSHOT_SCREENSHOTS_PATH] = test_images_dir_path
    end

    it 'iPad Pro (12.9-inch) (2nd generation) screenshots are copied as iPad Pro (12.9-inch) (3rd generation)' do
      puts("en-US filePath: #{enus_test_filepath}")
      puts("ja filePath: #{ja_test_filepath}")

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
    end

    after do
      FileUtils.rm_r(test_images_dir_path, { force: true })
      Fastlane::Actions.lane_context[Fastlane::Actions::SharedValues::SNAPSHOT_SCREENSHOTS_PATH] = nil
    end
  end
end
