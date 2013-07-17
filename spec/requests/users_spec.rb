require_relative '../spec_helper'

describe 'Users' do
  describe 'GET /users/home', type: :feature do

    before :all do
      @u = User.create! provider: 'facebook', uid: '9999', name: 'Tester Test',  image_url: 'http://some_img', email: 'tester@email.com', oauth_token: 'token', oauth_expires_at: Time.now + 86400
    end

    it 'should select the home tab', js: true do
      page.set_rack_session user_id: @u.id
      visit '/users/home'
      page.find('span.selected')['data-tab-name'].should == 'home'
    end
  end
end