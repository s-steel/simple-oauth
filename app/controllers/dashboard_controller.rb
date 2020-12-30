class DashboardController < ApplicationController
  def show
    response_page_1 = Faraday.get("https://api.github.com/user/repos", {}, {"Authorization": "token #{current_user.token}" })
    response_page_2 = Faraday.get("https://api.github.com/user/repos", {'page': '2'}, {"Authorization": "token #{current_user.token}" })
    @repos = JSON.parse(response_page_1.body, symbolize_names: true).concat(JSON.parse(response_page_2.body, symbolize_names: true))
  end
end
