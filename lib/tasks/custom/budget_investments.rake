namespace :budget_investments do
  desc "Set investments winners"
  task set_winners: :environment do
    ApplicationLogger.new.info "Set investments winners"
    ids = [
      2806,
      2767,
      2762,
      2755,
      2642,
      2541,
      2518,
      2517,
      2494,
      2472,
      2445,
      2443,
      2732,
      2644,
      2632,
      2542,
      2539,
      2520,
      2503,
      2496,
      2459,
      2453
    ]
    Budget::Investment.where(id: ids).update_all(winner: true, selected: true)
  end
end
