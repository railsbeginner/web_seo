class Website < ActiveRecord::Base
  validates_presence_of :name
  after_create :check_status
  has_many :responses
  belongs_to :user

  def check_status
    start_time = Time.now
    response = Faraday.get name
    response_time = Time.now - start_time
  end

end
