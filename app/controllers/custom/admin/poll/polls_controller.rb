require_dependency Rails.root.join("app", "controllers", "admin", "poll", "polls_controller").to_s
class Admin::Poll::PollsController
  private

    def poll_params
      attributes = [:name, :starts_at, :ends_at, :geozone_restricted, :budget_id, :related_sdg_list,
                     geozone_ids: [], image_attributes: image_attributes]
      custom_attributes = [:starts_at_hour, :ends_at_hour]
      params.require(:poll).permit(*attributes, *report_attributes, translation_params(Poll), *custom_attributes)
    end
end
