require "rails_helper"

describe Budgets::Investments::InfoComponent do
  it "renders the investment's own current milestone status, not another investment's" do
    heading = create(:budget_heading)
    status_a = create(:milestone_status, name: "Bidding")
    status_b = create(:milestone_status, name: "Executing the project")

    investment1 = create(:budget_investment, heading: heading, author_phone: "612345678")
    investment2 = create(:budget_investment, heading: heading, author_phone: "612345678")
    create(:milestone, milestoneable: investment1, status: status_b)
    create(:milestone, milestoneable: investment2, status: status_a)

    render_inline Budgets::Investments::InfoComponent.new(investment1)

    expect(page).to have_content(status_b.name)
    expect(page).not_to have_content(status_a.name)
  end
end
