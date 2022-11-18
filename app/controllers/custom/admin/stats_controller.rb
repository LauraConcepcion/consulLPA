require_dependency Rails.root.join("app", "controllers", "admin", "stats_controller").to_s

class Admin::StatsController
  def budget_balloting
    @budget = Budget.find(params[:budget_id])
    authorize! :read_admin_stats, @budget, message: t("admin.stats.budgets.no_data_before_balloting_phase")
    @vote_count = @budget.lines.count
    @vote_count_by_heading = @budget.lines.group(:heading_id).count.map { |k, v| [Budget::Heading.find(k).name, v] }.sort
    headings = @budget.lines.group(:heading_id).select(:heading_id).pluck(:heading_id)
    balloted_heading = User.where(balloted_heading_id: headings).group(:balloted_heading_id).count
    @user_count_by_district = balloted_heading.map { |k, v| [Budget::Heading.find(k).name, v] }.sort
    # Review the difference between the number of participants by listing the ballots and the balloted_headind
    @user_count = balloted_heading.values.sum
  end
end
