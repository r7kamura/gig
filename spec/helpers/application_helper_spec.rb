require "spec_helper"

describe ApplicationHelper do
  describe "#link_to_with_icon(icon_type, path, options = {})" do
    subject do
      helper.link_to_with_icon("icon_type", "/path")
    end

    it "creates icon tag with icon_type surrounded by link_to block" do
      should == '<a href="/path"><i class="icon-icon_type"></i></a>'
    end
  end

  describe "#current_action_classes" do
    subject do
      helper.content_tag(:body, :class => helper.current_action_classes) {}
    end

    before do
      helper.stub(:controller_name => "foo", :action_name => "bar")
    end

    it "creates a set of classes for current controller and action" do
      should == '<body class="foo_controller bar_action"></body>'
    end
  end
end
