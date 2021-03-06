class Website < ActiveRecord::Base
  validates_presence_of :name
  validates_url :name
  validates_uniqueness_of :name, message: ("Selected website has already been added")
  
  after_create :check_status_async
  has_many :responses, dependent: :destroy
  has_many :keywords
  belongs_to :user

  def check_status_async
    WebsiteWorker.perform_async(id)
  end

  def check_status    
    begin                                                                                                                                                                                                                                                                                   
      start_time = Time.now
      response = Faraday.get name
      puts response
      response_time = Time.now - start_time
      responses.create(response_time: response_time, status: response.status)
      self.update(average_response_time: responses.average(:response_time))
    rescue Faraday::Error::ConnectionFailed => e
      responses.create(response_time: nil, status: 503)
      errors.add(:connection, "is not available. We'll try to reach your domain later")
      puts "Connection failed. We'll try to reach your domain later"

      return

    end
  end

end
                                                                                                                                                                      