require 'test_helper'

class UserMailerTest < ActionMailer::TestCase

  test "welcome mail" do
    email = UserMailer.welcome_email('username',
                                     'user@example.com')

    assert_emails 1 do
      email.deliver_now
    end
 
    assert_equal ['no-reply@book-store.org'], email.from
    assert_equal ['user@example.com'], email.to
    assert_equal 'Welcome to BookStore!', email.subject
  end

  test "reset password mail" do
    email = UserMailer.reset_password_email('username',
                                            'user@example.com',
                                            '455tjygfj32')

    assert_emails 1 do
      email.deliver_now
    end
 
    assert_equal ['no-reply@book-store.org'], email.from
    assert_equal ['user@example.com'], email.to
    assert_equal 'Reset password at BookStore', email.subject
  end
end
