class CatRentalRequest < ActiveRecord::Base
  before_validation :default_values
  validates :cat_id, :presence => true
  validates :start_date, :presence => true
  validates :end_date, :presence => true
  validates :status, :presence => true, inclusion: { in: %w(PENDING APPROVED DENIED),message: "not an ok status" }
  validate :no_overlaps
  belongs_to(:cat)

    #def initialize()
     # @cat_id = options[:cat_id]
    #  @start_date = options[:start_date]
     # @end_date = options[:end_date]
      #@status = options[:status]
      #end


  # private

  def no_overlaps
    self.overlapping_approved_requests.empty?
  end

  def overlapping_requests
    # First, it has to grab all requests for the specified cat_id
    # Then, it compares the current requests start and end dates to see if it falls between any other request time period.
    CatRentalRequest.where(<<-SQL, {:cat_id => self.cat_id, :id => self.id, :start_date => self.start_date, :end_date => self.end_date})
    cat_rental_requests.cat_id = :cat_id
    AND cat_rental_requests.id != :id
    AND ((cat_rental_requests.start_date BETWEEN :start_date AND :end_date)
    OR (cat_rental_requests.end_date BETWEEN :start_date AND :end_date))
    SQL
  end

  def overlapping_approved_requests
    self.overlapping_requests.where("cat_rental_requests.status = 'APPROVED'")
  end

  def default_values
    self.status ||= 'PENDING'
  end
end
