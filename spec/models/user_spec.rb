require 'spec_helper'

describe User do
  before(:each) do
    @user = User.new
  end

  describe "A new User" do
    it "should have 0 posts" do
      @user.posts.size.should == 0
    end

    it "should not be banned" do
      @user.banned?.should be_false
    end

    it "should belong to group 4" do
      @user.groups.should match "4"
    end

    it "should be invalid without a username" do
      @user.username = ""
      @user.save
      @user.errors.messages.should include :username
      @user.errors.messages[:username].join.should include "blank"
      @user.username = "test"
      @user.save
      @user.errors.messages.should_not include :username
    end

    it "should be invalid if username has more than 20 characters" do
      @user.username = "abcdefghijklmnopqrstu"
      @user.save
      @user.errors.messages.should include :username
      @user.errors.messages[:username].join.should include "long"
      @user.username = "abcdefghijklmnopqrst"
      @user.save
      @user.errors.messages.should_not include :username
    end

    it "should be invalid if username contains weird characters" do
      @user.username = "`"
      @user.save
      @user.errors.messages.should include :username
      @user.errors.messages[:username].join.should include "invalid"
      @user.username = "?"
      @user.save
      @user.errors.messages.should include :username
      @user.errors.messages[:username].join.should include "invalid"
      @user.username = "\""
      @user.save
      @user.errors.messages.should include :username
      @user.errors.messages[:username].join.should include "invalid"
    end

    it "should be invalid without an email" do
      @user.email = ""
      @user.save
      @user.errors.messages.should include :email
      @user.errors.messages[:email].join.should include "blank"
      @user.email = "test@test.com"
      @user.save
      @user.errors.messages.should_not include :email
    end

    it "should be invalid if username or email is already taken" do
      User.create(:username => 'test',
        :password => 'test',
        :password_confirmation => 'test',
        :email => 'test@test.com',
        :valid_captcha => true)
      @user.username = "  tEsT  "
      @user.email = "   teSt@test.COm "
      @user.save
      @user.errors.messages.should include :username
      @user.errors.messages[:username].join.should include "taken"
      @user.errors.messages.should include :email
      @user.errors.messages[:email].join.should include "taken"
    end

    # password blank error handled by has_secure_password

    it "should be invalid if password confirmation do not match" do
      @user.password = "secret"
      @user.password_confirmation = "secret1"
      @user.save
      @user.errors.messages.should include :password
      @user.errors.messages[:password].join.should include "match"
      @user.password_confirmation = "secret"
      @user.save
      @user.errors.messages.should_not include :password
    end

    # TO DO, test captcha
  end
end
