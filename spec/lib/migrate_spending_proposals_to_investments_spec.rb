require "rails_helper"

describe MigrateSpendingProposalsToInvestments do

  let(:importer) { described_class.new }

  describe "#import" do

    it "Creates the budget if it doesn't exist" do
      sp = create(:spending_proposal)
      expect { importer.import(sp) }.to change{ Budget.count }.from(0).to(1)
      importer.import(create(:spending_proposal))
      expect(Budget.count).to eq(1)
    end

    it "Creates the budget and returns investments" do
      inv = nil
      sp = create(:spending_proposal)
      expect { inv = importer.import(sp) }.to change{ Budget::Investment.count }.from(0).to(1)
      expect(inv).to be_kind_of(Budget::Investment)
    end

    it "Imports a non georestricted spending proposal" do
      sp = create(:spending_proposal)

      inv = importer.import(sp)

      expect(inv.author).to eq(sp.author)
      expect(inv.title).to eq(sp.title)
      expect(inv.heading.name).to eq("Toda la ciudad")
      expect(inv.heading.group.name).to eq("Toda la ciudad")
    end

    it "Imports a district spending proposal" do
      sp = create(:spending_proposal, geozone: create(:geozone, name: "Bel Air"))

      inv = importer.import(sp)

      expect(inv.author).to eq(sp.author)
      expect(inv.title).to eq(sp.title)
      expect(inv.heading.name).to eq("Bel Air")
      expect(inv.heading.group.name).to eq("Distritos")
    end

    it "Uses existing budgets, headings and groups instead of creating new ones" do
      sp1 = create(:spending_proposal, geozone: create(:geozone, name: "Bel Air"))
      sp2 = create(:spending_proposal, geozone: create(:geozone, name: "Bel Air"))

      inv1 = importer.import(sp1)
      inv2 = importer.import(sp2)

      expect(inv2.heading).to eq(inv1.heading)
      expect(inv1.original_spending_proposal_id).to eq(sp1.id)
      expect(inv2.original_spending_proposal_id).to eq(sp2.id)
      expect(sp1.explanations_log).to eq(inv1.id)
      expect(sp2.explanations_log).to eq(inv2.id)
    end

    it "Imports feasibility correctly" do
      sp         = create(:spending_proposal)
      feasible   = create(:spending_proposal, feasible: true)
      unfeasible = create(:spending_proposal, feasible: false)

      expect(importer.import(sp).feasibility).to eq("undecided")
      expect(importer.import(feasible).feasibility).to eq("feasible")
      expect(importer.import(unfeasible).feasibility).to eq("unfeasible")
    end

    it "Imports valuation assignments" do
      sp = create(:spending_proposal)
      peter = create(:valuator)
      john = create(:valuator)
      sp.valuators << peter << john

      inv = importer.import(sp)

      expect(inv.valuator_assignments.count).to eq(2)
      expect(inv.valuators).to include(peter)
      expect(inv.valuators).to include(john)
    end

    it "Imports comments" do
      sp = create(:spending_proposal)
      create(:comment, commentable: sp, subject: "Wadus stuff")
      create(:comment, commentable: sp, subject: "More wadus")
      inv = importer.import(sp)

      expect(inv.comments_count).to eq(2)
    end
  end
end
