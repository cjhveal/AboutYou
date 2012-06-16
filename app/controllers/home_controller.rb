class HomeController < ApplicationController
  def index
  end

  def profile
  end

  def facebook_auth
    redirect_to authenticator.url_for_oauth_code(:permissions => FB_CONFIG[:scope])
  end

  def facebook_callback
    render 'profile'
  end

  protected
  def authenticator
    @authenticator ||= Koala::Facebook::OAuth.new(FB_CONFIG[:app_id], FB_CONFIG[:secret], url_for(:action => :facebook_callback))
  end
end
