require_dependency Rails.root.join("app", "models", "user").to_s
class User
  def minimum_votation_required_age?
    return false if date_of_birth.blank?

    Age.in_years(date_of_birth) >= User.minimum_required_age
  end

  def after_database_authentication
    if self.residence_verified_at && self.residence_verified_at < Time.current - 12.months
      date_of_birth_fmt = date_of_birth.strftime("%d/%m/%Y")
      r = CensusApi.new.call(document_type, document_number, date_of_birth_fmt)
      if r.valid?
        self.update_attribute(:residence_verified_at, Time.current)
      else
        self.update_attribute(:residence_verified_at, nil)
        self.update_attribute(:verified_at, nil)
      end
    end
  end
end
