class User < ActiveRecord::Base
  has_many :access_tokens, dependent: :destroy

  def self.find_or_create_by_token!(token)
    if user = find_by(token: token)
      user
    else
      table = QchanApi::GithubClient::Diagnoser.diagnose(token)
      create!(
        email: table["email"],
        name: table["login"],
        token: token,
      )
    end
  end

  def generate_access_token
    AccessToken.create(user_id: id)
  end
end
