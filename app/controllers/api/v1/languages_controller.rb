class Api::V1::LanguagesController < ApplicationController
  def index
    languages = Dnd5eDataGateway.fetch_langauges.map { |language_data| LanguagePoro.new(language_data) }
    render json: LanguageSerializer.new(languages, params: { detailed: false }).serializable_hash
  end

  def show
    language = LanguagePoro.new(Dnd5eDataGateway.fetch_langauges(params[:id]))
    render json: LanguageSerializer.new(language, params: { detailed: true }).serializable_hash
  end
end
