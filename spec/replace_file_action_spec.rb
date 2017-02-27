describe Fastlane::Actions::ReplaceFileAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The replace_file plugin is working!")

      Fastlane::Actions::ReplaceFileAction.run(nil)
    end
  end
end
