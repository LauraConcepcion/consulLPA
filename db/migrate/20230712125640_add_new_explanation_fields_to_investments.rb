class AddNewExplanationFieldsToInvestments < ActiveRecord::Migration[5.2]
  def change
    add_column :budget_investments, :next_year_budget_explanation, :text
    add_column :budget_investments, :takecharge_explanation, :text
  end
end
