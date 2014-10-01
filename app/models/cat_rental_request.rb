class CatRentalRequest < ActiveRecord::Base
  before_validation :default_values
  validates :cat_id, :presence => true
  validates :start_date, :presence => true
  validates :end_date, :presence => true
  validates :status, :presence => true, inclusion: { in: %w(PENDING APPROVED DENIED),message: "not an ok status" }
  validate :no_overlaps
  belongs_to(:cat)

  def approve!
    CatRentalRequest.transaction do
      self.status = "APPROVED"
      self.save!
      overlapping_pending_requests.each { |request| request.deny! }
    end
  end

  def deny!
    self.status = "DENIED"
    self.save!
  end

#  private

  def no_overlaps
    unless self.overlapping_approved_requests.empty? || self.status == "DENIED"
      errors[:base] << "Your rental timeframe has already been reserved!"
    end
  end

  def overlapping_requests
    # First, it has to grab all requests for the specified cat_id
    # Then, it compares the current requests start and end dates to see if it falls between any other request time period.
    CatRentalRequest.where(<<-SQL, {:cat_id => self.cat_id, :id => self.id, :start_date => self.start_date, :end_date => self.end_date})
    cat_rental_requests.cat_id = :cat_id
    AND ((:id IS NULL) OR (cat_rental_requests.id != :id))
    AND ((cat_rental_requests.start_date <= :end_date)
    AND (cat_rental_requests.end_date >= :start_date))
    SQL
  end

  def overlapping_pending_requests
    self.overlapping_requests.where("cat_rental_requests.status = 'PENDING'")
  end

  def overlapping_approved_requests
    self.overlapping_requests.where("cat_rental_requests.status = 'APPROVED'")
  end

  def default_values
    self.status ||= 'PENDING'
  end
end
