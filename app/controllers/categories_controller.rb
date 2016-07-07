class CategoriesController < ApplicationController

	def index
		@categories = Category.all
		@posts = Post.order(created_at: :desc).limit(6)
		@posts_month = Post.all.group_by { |post| post.created_at.strftime("%B %Y")}
		# @posts = Post.all(:select => "title, id, posted_at", :order => "posted_at DESC")
    	# @post_months = @posts.group_by { |t| t.posted_at.beginning_of_month }
		# @posts = Post.all
		# @months = []
		# @posts.each do |post|
		# 	@months.push (post.created_at.strftime("%B %Y") )
		# end
		# @uniqmonths =  @months.uniq
		# puts(@uniqmonths)
	end

	def new
		@category = Category.new
	end
	def create
		@category = Category.create(category_params)
		redirect_to '/categories'
	end

	def show
		@category = Category.find(params[:id])
		@posts = Post.where(category_id: @category.id)
		@is_category_creator = session[:user_id] == @category.created_by
		@category_user_name = User.find(@category.created_by).username
		@posts_month = Post.all.group_by { |post| post.created_at.strftime("%B %Y")}
	end

	def archive
		@month = params[:month]
		@month.sub!("January ", "01-")
		@month.sub!("February ", "02-")
		@month.sub!("March ", "03-")
		@month.sub!("April ", "04-")
		@month.sub!("May ", "05-")
		@month.sub!("June ", "06-")
		@month.sub!("July ", "07-")
		@month.sub!("August ", "08-")
		@month.sub!("September ", "09-")
		@month.sub!("October ", "10-")
		@month.sub!("November ", "11-")
		@month.sub!("December ", "12-")
		# @month.sub!("July ", "07-")
		#puts Post.where("strftime('%m-%Y', created_at) = ? ", @month).explain
		@posts = Post.where("strftime('%m-%Y', created_at) = ? ", @month)
		# @posts = Post.where({|post| post.created_at.strftime("%B %Y") == @month })

	end

	def edit
		@category = Category.find(params[:id])
	end

	def update
		@category = Category.find(params[:id])
		@category.update(category_params)
		redirect_to @category
	end

	def destroy
		@category = Category.find(params[:id])
		@category.destroy
		redirect_to '/categories'
	end

	private
	def category_params
		params.require(:category).permit(:title, :content, :image, :author, :created_by)
	end

end