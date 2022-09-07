require_dependency Rails.root.join("app", "controllers", "management", "budgets", "investments_controller").to_s
class Management::Budgets::InvestmentsController
  private

    def investment_params
      custom_attributes = [:author_phone]
      params.require(:budget_investment).permit(allowed_params, *custom_attributes)
    end
end
