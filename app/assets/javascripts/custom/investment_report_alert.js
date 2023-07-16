(function() {
  "use strict";
  App.InvestmentReportAlert = {
    initialize: function() {
      $("#js-investment-report-alert").on("click", function() {
        if (this.checked) {
          if ($("#budget_investment_feasibility_unfeasible").is(":checked")) {
            return confirm(this.dataset.alert + "\n" + this.dataset.notFeasibleAlert);
          } else if ($("#budget_investment_feasibility_notselected").is(":checked")) {
            return confirm(this.dataset.alert + "\n" + this.dataset.notSelectedAlert);
          } else if ($("#budget_investment_feasibility_takecharge").is(":checked")) {
            return confirm(this.dataset.alert + "\n" + this.dataset.takechargeAlert);
          } else if ($("#budget_investment_feasibility_nextyearbudget").is(":checked")) {
            return confirm(this.dataset.alert + "\n" + this.dataset.nextYearBudgetAlert);
          } else {
            return confirm(this.dataset.alert);
          }
        }
      });
    }
  };
}).call(this);
