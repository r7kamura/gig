require "spec_helper"

describe SessionsController do
  describe "#failure" do
    subject do
      get :failure
    end
    it { should redirect_to root_path }
  end

  describe "#destroy" do
    subject do
      delete :destroy
    end

    before do
      session[:user_id] = 1
    end

    it "deletes user_id from sessions and redirect_to root path" do
      should redirect_to root_path
      session[:user_id].should be_nil
    end
  end

  describe "#callback" do
    subject do
      get :callback
    end

    before do
      controller.env["omniauth.auth"] = {
        "uid"         => "uid",
        "provider"    => "provider",
        "info"        => { "nickname" => "nickname" },
        "credentials" => { "token"    => "token" },
      }
    end

    context "when there is no user matching given value" do
      it "creates a new user from env values and set user id to sessions" do
        should be_redirect
        should redirect_to User.first
        session[:user_id].should == User.first.id
      end
    end

    context "when there is a user matching given value" do
      let!(:user) do
        User.create(
          :nickname    => "nickname",
          :provider    => "provider",
          :token       => "token",
          :uid         => "uid"
        )
      end

      it "sets user id to sessions" do
        should redirect_to user
        session[:user_id].should == user.id
      end
    end
  end
end
