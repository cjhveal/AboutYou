class User < ActiveRecord::Base
  attr_accessible :auth_token, :date_of_birth, :email, :name, :uid, :website
end
