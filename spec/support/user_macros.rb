include Warden::Test::Helpers

def login
  Warden.test_mode!
  login_as(create(:user_with_account), scope: :user)
end