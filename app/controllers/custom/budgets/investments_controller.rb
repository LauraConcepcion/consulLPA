require_dependency Rails.root.join("app", "controllers", "budgets", "investments_controller").to_s
class Budgets::InvestmentsController
  valid_filters = %w[not_unfeasible feasible unfeasible unselected selected winners takecharged included_next_year_budget]

  has_filters valid_filters, only: [:index, :show, :suggest]

  private

    def investment_params
      custom_attributes = [:author_phone]
      params.require(:budget_investment).permit(allowed_params, *custom_attributes)
    end
end
