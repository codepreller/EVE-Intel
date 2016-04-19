class AllianceInReport < ActiveRecord::Base
  belongs_to :alliance
  belongs_to :report
end
