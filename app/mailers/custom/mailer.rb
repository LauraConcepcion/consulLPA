require_dependency Rails.root.join("app", "mailers", "mailer").to_s
class Mailer
  def budget_investment_feasible(investment)
    @investment = investment
    @author = investment.author
    @email_to = @author.email

    with_user(@author) do
      mail(
        to: @email_to,
        subject: t("mailers.budget_investment_feasible.subject", code: @investment.code)
      )
    end
  end

  def budget_investment_not_selected(investment)
    @investment = investment
    @author = investment.author
    @email_to = @author.email

    with_user(@author) do
      mail(
        to: @email_to,
        subject: t("mailers.budget_investment_not_selected.subject", code: @investment.code)
      )
    end
  end

  def budget_investment_takecharge(investment)
    @investment = investment
    @author = investment.author
    @email_to = @author.email

    with_user(@author) do
      mail(
        to: @email_to,
        subject: t("mailers.budget_investment_takecharge.subject", code: @investment.code)
      )
    end
  end

  def budget_investment_next_year_budget(investment)
    @investment = investment
    @author = investment.author
    @email_to = @author.email

    with_user(@author) do
      mail(
        to: @email_to,
        subject: t("mailers.budget_investment_next_year_budget.subject", code: @investment.code)
      )
    end
  end
end
