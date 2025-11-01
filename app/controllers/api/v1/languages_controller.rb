class Api::V1::LanguagesController < ApplicationController
  def index
    languages = Dnd5eDataGateway.fetch_langauges.map { |language_data| LanguagePoro.new(language_data) }
    render json: LanguageSerializer.new(languages, params: { detailed: false }).serializable_hash
  end

  def show
    language = Dnd5eDataGateway.fetch_langauges(params[:id])

    if language
      render json: LanguageSerializer.new(LanguagePoro.new(language), params: { detailed: true }).serializable_hash
    else
      render json: { error: "Language not found" }, status: :not_found
    end
  end
end
