require_dependency Rails.root.join("app", "controllers", "admin", "budget_investments_controller").to_s
class Admin::BudgetInvestmentsController
  private

    def budget_investment_params
      custom_attributes = [:organization_name, :location, :not_selected]
      params.require(:budget_investment).permit(allowed_params, *custom_attributes)
    end
end
