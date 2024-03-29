require_dependency Rails.root.join("app", "controllers", "admin", "budget_investments_controller").to_s
class Admin::BudgetInvestmentsController
  private

    def budget_investment_params
      attributes = [:external_url, :heading_id, :administrator_id, :tag_list,
                    :valuation_tag_list, :incompatible, :visible_to_valuators, :selected,
                    :milestone_tag_list, valuator_ids: [], valuator_group_ids: []]
      custom_attributes = [:organization_name, :location, :not_selected]
      params.require(:budget_investment).permit(*attributes, translation_params(Budget::Investment), *custom_attributes)
    end
end
