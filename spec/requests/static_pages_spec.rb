require_relative '../spec_helper'

describe "Static pages" do

  describe "Login page", :type => :feature do

    ['Welcome to my app!', 'Sign in with Facebook'].each do |content|
      it "should has the content '#{content}'" do
        visit '/sessions/new'
        page.should have_content content
      end
    end

  end

end