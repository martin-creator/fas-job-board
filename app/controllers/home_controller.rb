class HomeController < ApplicationController
  def show
    @developers = Developer
      .with_attached_avatar
      .available.newest_first
      .limit(10)
  end
end
