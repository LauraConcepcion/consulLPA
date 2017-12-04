require_dependency Rails.root.join('app', 'controllers', 'admin', 'poll', 'polls_controller').to_s

class Admin::Poll::PollsController
  private

    def poll_params
      params.require(:poll).permit(:name, :starts_at, :starts_at_hour, :ends_at, :ends_at_hour, :geozone_restricted,
                                  :summary, :description, :results_enabled, :stats_enabled,
                                  geozone_ids: [],
                                  image_attributes: [:id, :title, :attachment, :cached_attachment, :user_id, :_destroy])
    end

end
