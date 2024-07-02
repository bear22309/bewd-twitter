class TweetsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]

  def index
    tweets = Tweet.all
    render json: tweets
  end

  def index_by_user
    user = User.find_by(username: params[:username])
    if user
      tweets = user.tweets
      render json: tweets
    else
      render json: { error: 'User not found' }, status: :not_found
    end
  end

  def create
    tweet = current_user.tweets.new(tweet_params)
    if tweet.save
      render json: tweet, status: :created
    else
      render json: { errors: tweet.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    tweet = current_user.tweets.find_by(id: params[:id])
    if tweet
      tweet.destroy
      render json: { message: 'Tweet deleted' }, status: :ok
    else
      render json: { error: 'Tweet not found' }, status: :not_found
    end
  end

  private

  def tweet_params
    params.require(:tweet).permit(:message)
  end

  def authenticate_user!
    @current_user = Session.find_by(token: cookies[:twitter_session_token])&.user
    render json: { error: 'Not authenticated' }, status: :unauthorized unless @current_user
  end

  def current_user
    @current_user
  end
end

