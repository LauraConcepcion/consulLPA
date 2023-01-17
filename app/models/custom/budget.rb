require_dependency Rails.root.join("app", "models", "budget").to_s
class Budget
  def formatted_amount(amount)
    ActionController::Base.helpers.number_to_currency(amount,
                                                      precision: 2,
                                                      locale: I18n.locale,
                                                      unit: currency_symbol)
  end

  def investments_orders
    case phase
    when "accepting", "reviewing", "finished"
      %w[random]
    when "publishing_prices", "balloting", "reviewing_ballots"
      %w[price]
    else
      %w[random confidence_score]
    end
  end
end
