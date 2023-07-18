class AddFeasibleEmailSentAtToInvestments < ActiveRecord::Migration[5.2]
  def change
    add_column :budget_investments, :feasible_email_sent_at, :datetime
  end
end
