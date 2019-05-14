require 'test_helper'

class MailerWorkerTest < MiniTest::Test

  def test_mailer_after_registration
    MailerWorker.clear
    MailerWorker.perform_async("John", "example@mail.com")
    assert_equal 1, MailerWorker.jobs.size
    MailerWorker.drain
    assert_equal 0, MailerWorker.jobs.size
  end

end