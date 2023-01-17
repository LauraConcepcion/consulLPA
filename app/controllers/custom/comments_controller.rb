require_dependency Rails.root.join("app", "controllers", "comments_controller").to_s
class CommentsController
  before_action :authenticate_user!, only: [:create, :update]
  before_action :load_commentable, only: [:create, :update]
  before_action :verify_resident_for_commentable!, only: :create
  before_action :verify_comments_open!, only: [:create, :vote]
  before_action :build_comment, only: :create
  before_action :update_comment, only: :update

  def create
    if @comment.save
      if @comment.commentable_type == "Poll::Question"
        render :create_poll_question
      else
        CommentNotifier.new(comment: @comment).process
        add_notification @comment
        EvaluationCommentNotifier.new(comment: @comment).process if send_evaluation_notification?
      end
    else
      render :new
    end
  end

  def update
    render :edit unless @comment.save
  end

  private

    def update_comment
      @comment = Comment.find(params[:id])
      @comment.body = comment_params[:body]
    end
end
