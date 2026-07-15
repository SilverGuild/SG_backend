require 'rails_helper'

RSpec.describe Dnd5eCacheRefreshJob, type: :job do
  describe "#perform" do
    it "refreshes every category" do
      Dnd5eCacheRefreshJob::CATEGORIES.each do |category|
        expect(Dnd5eDataGateway).to receive(:refresh).with(category)
      end

      Dnd5eCacheRefreshJob.perform_now
    end

    it "continues refershing remaining categories when one fails" do
      failing_category = "races"

      Dnd5eCacheRefreshJob::CATEGORIES.each do |category|
        if category == failing_category
          allow(Dnd5eDataGateway).to receive(:refresh).with(category)
            .and_raise(Dnd5eDataGateway::UnavailableError, "boom")
        else
          allow(Dnd5eDataGateway).to receive(:refresh).with(category)
        end
      end
      allow(Rails.logger).to receive(:error)

      expect { Dnd5eCacheRefreshJob.perform_now }.not_to raise_error

      expect(Dnd5eDataGateway).to have_received(:refresh).with(failing_category)
      expect(Dnd5eDataGateway).to have_received(:refresh).with("languages")
      expect(Rails.logger).to have_received(:error).with(a_string_matching(/races/))
    end
  end
end
