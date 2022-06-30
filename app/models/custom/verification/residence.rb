require_dependency Rails.root.join("app", "models", "verification", "residence").to_s

class Verification::Residence

  validate :allowed_age
  validate :local_postal_code
  validate :local_residence
  validates :date_of_birth, presence: true

  VALID_POSTAL_CODES = (35001..35019).to_a + [35220, 35229]

  def local_postal_code
    errors.add(:postal_code, I18n.t('verification.residence.new.error_not_allowed_postal_code')) unless valid_postal_code?
  end

  def local_residence
    return if errors.any?

    unless residency_valid?
      errors.add(residency_errors, false)
      store_failed_attempt
      Lock.increase_tries(user)
    end
  end

  def allowed_age
    return if errors[:date_of_birth].any?

    unless allowed_age?
      errors.add(:date_of_birth, I18n.t('verification.residence.new.error_not_allowed_age'))
    end
  end

  private

    def retrieve_census_data
      @census_data = CensusCaller.new.call(document_type, document_number, date_of_birth)
    end

    def valid_postal_code?
      postal_code.to_i.in?(VALID_POSTAL_CODES)
    end

    def residency_valid?
      @census_data.valid?
    end

    def gender
      # TODO: Decide if we get district from web service or form
      '-'
    end

    def district_code
      @census_data.district_code
    end

    def residency_errors
      @census_data.errors
    end

    def allowed_age?
      Age.in_years(date_of_birth) >= User.minimum_required_age
    end

    def document_number_uniqueness
      errors.add(:document_number, I18n.t("errors.messages.taken")) if User.active.where(document_number: document_number).where.not(id: user.id).any?
    end
end
