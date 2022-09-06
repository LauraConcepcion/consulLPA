require_dependency Rails.root.join("lib", "census_caller").to_s
class CensusCaller
  def call(document_type, document_number, date_of_birth)
    return Response.new if document_number.blank? || document_type.blank?

    if Setting["feature.remote_census"].present?
      response = RemoteCensusApi.new.call(document_type, document_number, date_of_birth)
    else
      response = CensusApi.new.call(document_type, document_number, date_of_birth)
    end
    response = LocalCensus.new.call(document_type, document_number) unless response.valid?

    response
  end
end
