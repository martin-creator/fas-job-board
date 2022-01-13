class DevelopersController < ApplicationController
  include Pagy::Backend

  before_action :authenticate_user!, only: %i[new create edit update]
  before_action :require_new_developer!, only: %i[new create]

  def index
    if params[:search]
      @query = DeveloperQuery.new(search_params)
    else
      developers = Developer
        .includes(:role_type).with_attached_avatar
        .newest_first

      @pagy, @developers = pagy(developers)
    end
  end

  def new
    @developer = current_user.build_developer
  end

  def create
    @developer = current_user.build_developer(developer_params)

    if @developer.save
      redirect_to @developer, notice: t(".created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @developer = Developer.friendly.find(params[:id])
    authorize @developer
  end

  def update
    @developer = Developer.friendly.find(params[:id])
    authorize @developer

    if @developer.update(developer_params)
      redirect_to @developer, notice: t(".updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def show
    @developer = Developer.friendly.find(params[:id])
  end

  private

  def require_new_developer!
    if current_user.developer.present?
      redirect_to edit_developer_path(current_user.developer)
    end
  end

  def developer_params
    params[:developer][:technical_skills] = DevelopersHelper.sanitize_skills(params[:developer][:technical_skills]) if params[:developer][:technical_skills]
    params[:developer][:pivot_skills] = DevelopersHelper.sanitize_skills(params[:developer][:pivot_skills]) if params[:developer][:pivot_skills]

    params.require(:developer).permit(
      :name,
      :available_on,
      :hero,
      :bio,
      :technical_skills,
      :pivot_skills,
      :website,
      :github,
      :twitter,
      :linkedin,
      :avatar,
      :cover_image,
      :search_status,
      :time_zone,
      role_type_attributes: [
        :part_time_contract,
        :full_time_contract,
        :full_time_employment
      ]
    )
  end

  def search_params
    params.require(:search).permit(
      :search_field,
      :job_type,
      :availability
    )
  end
end
