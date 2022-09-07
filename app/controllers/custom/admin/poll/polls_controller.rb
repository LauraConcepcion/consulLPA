require_dependency Rails.root.join("app", "controllers", "admin", "poll", "polls_controller").to_s
class Admin::Poll::PollsController
  private

    def poll_params
      custom_attributes = [:starts_at_hour, :ends_at_hour]
      params.require(:poll).permit(allowed_params, *custom_attributes)
    end
end
