class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:home, :show]
  before_action :redirect_unless_comm!, except: [:home, :show]
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def home
    @featured_posts = Post.all_posts.visible.featured.limit(2)
    @other_posts = Post.all_posts.visible.where.not(id: [@featured_posts.map(&:id)])
  end

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all.order(id: :desc)
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)
    @post.user = current_user
    if @post.save
      redirect_to @post, flash: { success: 'Post was successfully created.' }
    else
      render :new
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    if @post.update(post_params)
      redirect_to @post, flash: { success: 'Post was successfully updated.' }
    else
      render :edit
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    redirect_to posts_url, flash: { success: 'Post was successfully destroyed.' }
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params[:id])
    unless @post.user_can_view?(current_user)
      raise ActiveRecord::RecordNotFound.new("Not Found")
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def post_params
    params.require(:post).permit(:title, :body, :slug, :feature, :draft, :competition_page)
  end
end
