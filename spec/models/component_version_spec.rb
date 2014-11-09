require 'rails_helper'

RSpec.describe ComponentVersion, :type => :model do
  context "creating a component version" do
    subject{ FactoryGirl.build :component_version_1}
    its(:save){ should be true }
  end
end
