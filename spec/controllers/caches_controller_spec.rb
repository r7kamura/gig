require "spec_helper"

describe CachesController do
  describe "#create" do
    subject do
      post :create, :payload => payload
    end

    before do
      controller.stub(:author => author)
      request.stub(:user_agent => user_agent)
    end

    let(:author) do
      mock
    end

    let(:user_agent) do
      "GitHub Services Web Hook"
    end

    let(:payload) do
      JSON.unparse(
        "commits" => [
          {
            "added"    => ["#{Settings.github.entries_path}/added_path"],
            "modified" => ["#{Settings.github.entries_path}/modified_path"],
            "removed"  => ["#{Settings.github.entries_path}/removed_path"],
          }
        ]
      )
    end

    it "updates caches of changed files and entries list" do
      Rails.cache.should_receive(:delete).exactly(4).times
      author.should_receive(:entry).exactly(3).times
      author.should_receive(:entries)
      should be_ok
    end

    context "when not requested from GitHub Post-Receive Hooks" do
      let(:user_agent) do
        "Rails Testing"
      end

      it { should be_bad_request }
    end
  end
end
