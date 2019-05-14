require 'test_helper'

class PasswordResetWorkerTest < MiniTest::Test
    
    def test_mailer_restore_password
        
        PasswordResetWorker.clear
        PasswordResetWorker.perform_async('user', 'user@mail.com', 'token30139')
        assert_equal 1, PasswordResetWorker.jobs.size
        PasswordResetWorker.drain
        assert_equal 0, PasswordResetWorker.jobs.size
    end
end
