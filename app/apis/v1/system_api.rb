class V1::SystemApi < Grape::API

  before do
    token_authenticate!
  end

  namespace :system do

    post "upload_log" do
    end

  end

end
