class WebApplication < ActiveRecord::Base
  include Requester
  extend FriendlyId

  validates_presence_of :name, :status_url
  validates_uniqueness_of :name
  validate :status_url_is_valid
  has_and_belongs_to_many :users, autosave: true
  friendly_id :name, use: :slugged

  def get_status
    status = get(status_url)
    status.try(:[], "status")
  end

private

  def status_url_is_valid
    begin
      get_status
    rescue
      errors.add(:status_url, "does not return a valid response")
    end
  end
end
