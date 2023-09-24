class PostsController < ApplicationController
 
    before_action :set_post, only: [:show, :update, :destroy]
    before_action :authorize_user, only: [:update, :destroy]
  
    # ...
    def create
      @post=Post.new(post_params)
      if @post.save
        render json: @post, status: :created, location: @post
      else
        render json: @post.errors, status: :unprocessable_entity
      end

    end
    
    def update
      if @post.update(post_params)
        render json: @post, status: :ok
      else
        render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    def destroy
      @post.destroy
      render json: { message: 'Post deleted successfully' }, status: :ok
    end
  
    private
  
    def set_post
      @post = Post.find(params[:id])
    end
  
    def post_params
      params.require(:post).permit(:title, :description)
    end
  
    def authorize_user
      unless @post.user == current_user
        render json: { error: 'Not Authorized' }, status: :unauthorized
      end
    end
  end
end
