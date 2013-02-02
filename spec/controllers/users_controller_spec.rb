require "spec_helper"

describe UsersController do
  let(:user) do
    FactoryGirl.create(:user)
  end

  describe "#index" do
    subject do
      get :index
    end

    it { should be_ok }
  end

  describe "#show" do
    subject do
      get :show, :id => user.nickname
    end

    it { should be_ok }
  end
end
