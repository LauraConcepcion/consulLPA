require_dependency Rails.root.join("app", "models", "user").to_s
class User

  def strf_date_of_birth
    date_of_birth.strftime("%d/%m/%Y")
  end

  def minimum_votation_required_age?
    return false if date_of_birth.blank?

    Age.in_years(date_of_birth) >= User.minimum_required_age
  end

  def verify_residence_verified_at
    if self.residence_verified_at && self.residence_verified_at < Time.current - 12.months
      date_of_birth_fmt = strf_date_of_birth
      r = CensusApi.new.call(document_type, document_number, date_of_birth_fmt)
      if r.valid?
        self.update_attribute(:residence_verified_at, Time.current)
      else
        logger.info "Error de #{self.id} al verificarse"
        logger.info r.errors.present? ? r.errors : ""
        self.update_attribute(:residence_verified_at, nil)
        self.update_attribute(:verified_at, nil)
      end
    end
  end

  def after_database_authentication
    verify_residence_verified_at
  end

  private

    def logger
      ApplicationLogger.new
    end
end
