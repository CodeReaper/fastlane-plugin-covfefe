describe Fastlane::Actions::CovfefeAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The covfefe plugin is working!")

      Fastlane::Actions::CovfefeAction.run(nil)
    end
  end
end
