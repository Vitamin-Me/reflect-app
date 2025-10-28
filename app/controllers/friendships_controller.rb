class FriendshipsController < ApplicationController
  before_action :authenticate_user!
  def index
    @friends = current_user.friends
    if params[:query].present?
      @results = User.where("username ILIKE ?", "%#{params[:query]}%").where.not(id: current_user.id)
    else
      @results = []
    end
  end

  def create
    friend = User.find(params[:friend_id])

    unless current_user.friends.include?(friend)
      current_user.friendships.create(friend: friend)
      flash[:notice] = "#{friend.username} has been added as a friend!"
    else
      flash[:alert] = "You are already friends with #{friend.username}."
    end

    redirect_to friends_path
  end
end
