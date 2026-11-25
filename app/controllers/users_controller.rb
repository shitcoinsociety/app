class UsersController < ApplicationController
  USERS_PER_PAGE = 20

  def show
    user = params[:handle].present? ? User.find_by!(handle: params[:handle]) : User.find(params[:id])
    @user = user.as_json(User::PUBLIC_JSON)
  end

  def new
    @user_count = User.count
  end

  def index
    after = params[:after]
    if params.key?(:after) && (!after.is_a?(String) || !after.match?(/\A[1-9]\d{0,18}\z/) || after.to_i > 9_223_372_036_854_775_807)
      return head :bad_request
    end

    users = User.order(:id)
    users = users.where("id > ?", after.to_i) if after.present?
    users = users.with_attached_profile_image.limit(USERS_PER_PAGE + 1).to_a
    has_more = users.length > USERS_PER_PAGE
    users = users.first(USERS_PER_PAGE)

    @users = InertiaRails.merge(match_on: "id") { users.as_json(User::PUBLIC_JSON) }
    @next_cursor = has_more ? users.last.id : nil
    @user_count = User.count
  end
end
