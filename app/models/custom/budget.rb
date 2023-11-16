require_dependency Rails.root.join("app", "models", "budget").to_s
class Budget
  include Rails.application.routes.url_helpers

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

  def self.change_phase
    self.change_active_phases
  end

  private

    def self.active_bugets
      Budget.all.reject{|budget| budget.finished?}
    end

    def self.change_active_phases
      notifier = SlackNotifier.new
      self.active_bugets.map do |budget|
        previous_phase = budget.phase
        next_phase = budget.published_phases.find do |phase|
          phase.starts_at == Time.zone.now
        end
        if next_phase.present?
          budget.phase = next_phase.kind
          if budget.save
            notifier.post text: I18n.t('general.slack.budgets.phase_change.success', budget_name: budget.name,
            previous_phase: I18n.t("budgets.phase.#{previous_phase}"),
            next_phase: I18n.t("budgets.phase.#{next_phase.kind}"))
          else
            notifier.post text: I18n.t('general.slack.budgets.phase_change.error')
          end
        end
      end
    end
end
