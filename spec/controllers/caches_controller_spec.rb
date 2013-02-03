require "spec_helper"

describe CachesController do
  describe "#create" do
    subject do
      post :create, :payload => payload
    end

    before do
      FactoryGirl.create(:user, :nickname => "test")
      request.stub(:user_agent => user_agent)
    end

    let(:user_agent) do
      "GitHub Services Web Hook"
    end

    let(:payload) do
      JSON.unparse(
        "commits" => [
          {
            "added"    => ["test/#{Settings.github.entries_path}/added_path"],
            "modified" => ["test/#{Settings.github.entries_path}/modified_path"],
            "removed"  => ["test/#{Settings.github.entries_path}/removed_path"],
          }
        ],
        "repository" => {
          "owner" => {
            "name" => "test",
          },
        },
      )
    end

    it "updates caches of changed files and entries list" do
      Rails.cache.should_receive(:delete).exactly(6)
      User.any_instance.should_receive(:entry).exactly(3)
      User.any_instance.should_receive(:entries).exactly(1)
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
