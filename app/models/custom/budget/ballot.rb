require_dependency Rails.root.join("app", "models", "budget", "ballot").to_s
class Budget::Ballot
  def total_amount_spent
    investments.sum(:price)
  end
end
