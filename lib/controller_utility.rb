module ControllerUtility

  def set_pagination(params)
    @page = params[:page]
    @per_page = params[:size]
    @page ||= 1
    @per_page || = 10
  end

  def record_not_found
    render json: { data: {
        status: "Error",
        error: "We can't find a valid record"
      }
    }, status: :not_found
  end

  def record_error
    render json: { data: {
        status: "Error"
      }

    }, status: :internal_server_error
  end

  def operation_not_allowed
    render json: { data: {
        status: "Error",
        error: "You are not the owner of this branch"
      }
    }, status: :unauthorized
  end

end