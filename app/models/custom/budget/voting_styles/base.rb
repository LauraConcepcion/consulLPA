require_dependency Rails.root.join("app", "models", "budget", "voting_styles", "base").to_s
class Budget::VotingStyles::Base
  private

    def investments_price(heading)
      investments(heading).sum(:price)
    end
end
