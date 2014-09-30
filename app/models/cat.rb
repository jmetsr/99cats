class Cat < ActiveRecord::Base
  COLORS = %w(orange brown white black yellow)

  validate :timeliness
  validates :color, inclusion: { in: COLORS,
    message: "not a valid color" }
  validates :sex, inclusion: { in: %w(M F),
    message: "not a good cat sex" }
  validates :birth_date, :color, :sex, :name, :description, presence: :true

  has_many(:cat_rental_requests)
  before_destroy :dependent => :destroy

  def age
    Date.today - self.birth_date
  end

  private

  def timeliness
    if self.birth_date && self.birth_date > Date.today
      errors[:birth_date] << "cat cannot be born in the future!"
    end
  end

end