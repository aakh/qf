class CommentsController < ApplicationController
  before_filter :check_logged_in
  
  def create
    @commentable = find_commentable
    @comment = @commentable.comments.build(params[:comment])
    @comment.user = current_user if current_user
    if @comment.save  
      flash[:notice] = "Thanks for the comment."
      redirect_to :back
    else  
      flash[:error] = "Could not create comment."
      redirect_to :back
    end 
  end
  
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    flash[:notice] = "Successfully deleted comment."
    redirect_to :back
  end
  
  def find_commentable  
    params.each do |name, value|  
      if name =~ /(.+)_id$/  
        return $1.classify.constantize.find(value)  
      end  
    end  
    nil  
  end
  
end
