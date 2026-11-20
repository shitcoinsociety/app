class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  use_inertia_instance_props

  inertia_share magic_link_sent: -> { params[:magic_link_sent].to_s == "true" },
                current_user_id: -> { session[:user_id] },
                current_user_token: -> {
                  current_user && DexieChannel.stream_token_for(current_user)
                }

  rescue_from ActiveRecord::RecordInvalid do |exception|
    # raise exception unless request.inertia?
    errors = exception.record.errors

    flash[:alert] = errors.full_messages.first

    redirect_back inertia: {
      errors: exception.record.errors
    }
  end

  rescue_from ActionController::BadRequest do |exception|
    flash[:alert] = exception.message
    redirect_back(fallback_location: root_path, status: :see_other)
  end

  def inertia_referer
    request.headers["X-Inertia-Referer"]
  end

  def redirect_back(frame: nil, **options)
    if request.inertia?
      redirect_to inertia_referer, **options, status: :see_other
    else
      super(**options)
    end
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end
end
