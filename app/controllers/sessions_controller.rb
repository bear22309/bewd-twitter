# app/controllers/sessions_controller.rb

class SessionsController < ApplicationController
  # POST /sessions
  def create
    user = User.find_by(username: params[:user][:username])

    if user&.authenticate(params[:user][:password])
      @session = user.sessions.create!
      cookies.permanent.signed[:twitter_session_token] = @session.token
      render json: {
        id: @session.id,
        token: @session.token,
        user_id: @session.user_id,
        created_at: @session.created_at,
        updated_at: @session.updated_at
      }, status: :created
    else
      render json: { error: 'Invalid credentials' }, status: :unauthorized
    end
  end

  # GET /authenticated
  def authenticated
    session = Session.find_by(token: cookies.signed[:twitter_session_token])

    if session && session.user
      render json: { authenticated: true, username: session.user.username }
    else
      render json: { authenticated: false }, status: :unauthorized
    end
  end

  # DELETE /sessions
  def destroy
    session = Session.find_by(token: cookies.signed[:twitter_session_token])

    if session
      session.destroy
      cookies.delete(:twitter_session_token)
      render json: { success: true }, status: :ok
    else
      render json: { error: 'Invalid session' }, status: :unauthorized
    end
  end
end

