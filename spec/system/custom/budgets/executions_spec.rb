require "rails_helper"

describe "Executions" do
  let(:budget)  { create(:budget, :finished) }
  let(:group)   { create(:budget_group, budget: budget) }
  let(:heading) { create(:budget_heading, group: group) }
  let(:phone)   { "612345678" }

  let!(:investment1) { create(:budget_investment, :winner, heading: heading, author_phone: phone) }
  let!(:investment2) { create(:budget_investment, :winner, heading: heading, author_phone: phone) }

  context "Milestone status label" do
    scenario "displays the investment's own current status, not another investment's" do
      status_a = create(:milestone_status, name: "Bidding")
      status_b = create(:milestone_status, name: "Executing the project")

      create(:milestone, milestoneable: investment1, status: status_b)
      create(:milestone, milestoneable: investment2, status: status_a)

      visit budget_path(budget)
      click_link "See results"
      click_link "Milestones"

      within(".budget-execution", text: investment1.title) do
        expect(page).to have_content(status_b.name)
        expect(page).not_to have_content(status_a.name)
      end

      within(".budget-execution", text: investment2.title) do
        expect(page).to have_content(status_a.name)
        expect(page).not_to have_content(status_b.name)
      end
    end
  end
end
