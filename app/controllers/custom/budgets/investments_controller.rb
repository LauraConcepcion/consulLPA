require_dependency Rails.root.join("app", "controllers", "budgets", "investments_controller").to_s
class Budgets::InvestmentsController
  valid_filters = %w[not_unfeasible feasible unfeasible unselected selected winners takecharged included_next_year_budget]

  has_filters valid_filters, only: [:index, :show, :suggest]

  private

    def investment_params
      attributes = [:heading_id, :tag_list,
                    :organization_name, :location,
                    :terms_of_service, :related_sdg_list,
                    :author_phone,
                    image_attributes: image_attributes,
                    documents_attributes: document_attributes,
                    map_location_attributes: map_location_attributes]
      params.require(:budget_investment).permit(attributes, translation_params(Budget::Investment))
    end
end
