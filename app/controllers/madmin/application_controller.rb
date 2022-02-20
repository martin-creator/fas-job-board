module Madmin
  class ApplicationController < Madmin::BaseController
    before_action :require_admin!
    before_action :authenticate_user!

    protected

    def require_admin!
      redirect_to "/" unless current_user.admin?
    end
  end
end
