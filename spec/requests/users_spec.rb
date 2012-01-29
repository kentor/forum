require 'spec_helper'

describe "Users" do
  describe "get /register" do
    it "displays registration form" do
      visit new_user_path
      page.should have_content "Username"
    end
  end
end
