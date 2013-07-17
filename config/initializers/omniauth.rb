ENV['FACEBOOK_APP_ID'] = '1398940933652550'
ENV['FACEBOOK_SECRET'] = 'a38e534b4b6734263af01499a4455939'

OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_SECRET']
end