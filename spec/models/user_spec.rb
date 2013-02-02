require "spec_helper"

describe User do
  describe ".find_or_create_from_auth" do
    subject do
      described_class.find_or_create_from_auth(auth)
    end

    # an example auth information of omniauth's one
    let(:auth) do
      {
        "uid"         => 1,
        "provider"    => "github",
        "credentials" => { "token"    => "token" },
        "info"        => { "nickname" => "nickname" },
      }
    end

    context "when the matched user is not created yet" do
      it "creates a new user from a given auth info" do
        should be_a described_class
        should be_persisted
        described_class.should have(1).user
      end
    end

    context "when the matched user already exists" do
      before do
        described_class.find_or_create_from_auth(auth)
      end

      it "finds the user" do
        should be_a described_class
        should be_persisted
        described_class.should have(1).user
      end
    end
  end

  describe ".admin" do
    let!(:admin) do
      FactoryGirl.create(:admin, :nickname => "test")
    end

    before do
      FactoryGirl.create(:user)
    end

    it "returns admin user" do
      described_class.admin.should == admin
    end
  end
end
