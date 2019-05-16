require 'test_helper'

class StaticPageControllerTest < ActionDispatch::IntegrationTest
  
  test 'should show main page' do
    get '/'
    assert_response :success  
  end

end
