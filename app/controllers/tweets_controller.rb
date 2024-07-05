# app/controllers/tweets_controller.rb

class TweetsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]

  # GET /tweets
  def index
    tweets = Tweet.includes(:user).order(created_at: :desc)
    render json: tweets.map { |tweet| { id: tweet.id, username: tweet.user.username, message: tweet.message } }
  end

  # GET /users/:username/tweets
  def index_by_user
    user = User.find_by(username: params[:username])
    if user
      tweets = user.tweets.order(created_at: :desc)
      render json: tweets.map { |tweet| { id: tweet.id, username: tweet.user.username, message: tweet.message } }
    else
      render json: { error: 'User not found' }, status: :not_found
    end
  end

  # POST /tweets
  def create
    tweet = current_user.tweets.build(tweet_params)

    if tweet.save
      render json: { tweet: { id: tweet.id, username: current_user.username, message: tweet.message } }, status: :created
    else
      render json: { errors: tweet.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /tweets/:id
  def destroy
    tweet = current_user.tweets.find_by(id: params[:id])
    if tweet
      tweet.destroy
      render json: { success: true }, status: :ok
    else
      render json: { error: 'Tweet not found' }, status: :not_found
    end
  end

  private

  def tweet_params
    params.require(:tweet).permit(:message)
  end

  def authenticate_user!
    @current_user = Session.find_by(token: cookies.signed[:twitter_session_token])&.user
    unless @current_user
      render json: { error: 'Not authenticated' }, status: :unauthorized
    end
  end

  def current_user
    @current_user
  end
end

