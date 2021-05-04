describe Fastlane::Actions::CopyScreenshotsAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The copy_screenshots plugin is working!")

      Fastlane::Actions::CopyScreenshotsAction.run(nil)
    end
  end
end
