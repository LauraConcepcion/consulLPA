require_dependency Rails.root.join("app", "models", "user").to_s
class User
  def minimum_votation_required_age?
    return false if date_of_birth.blank?

    Age.in_years(date_of_birth) >= User.minimum_required_age
  end

  def verify_residence_verified_at
    # Rollback this when the process has completed
    # && residence_verified_at < Time.current - 12.months
    if level_two_or_three_verified?
      date_of_birth_fmt = I18n.l(date_of_birth.to_date)
      r = CensusApi.new.call(document_type, document_number, date_of_birth_fmt)
      if r.valid?
        update_attribute(:residence_verified_at, Time.current)
      else
        logger.info "Error de #{id} al verificarse"
        logger.info r.errors.presence || ""
        update_attribute(:residence_verified_at, nil)
        update_attribute(:verified_at, nil)
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
