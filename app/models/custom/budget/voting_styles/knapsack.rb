require_dependency Rails.root.join("app", "models", "budget", "voting_styles", "knapsack").to_s
class Budget::VotingStyles::Knapsack
  def enough_resources?(investment)
    investment.price <= amount_available(investment.heading)
  end
end
