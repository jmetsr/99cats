class Cat < ActiveRecord::Base
  validate :timeliness
  validates :color, inclusion: { in: %w(orange brown white black yellow),
    message: "not a valid color" }
  validates :sex, inclusion: { in: %w(M F),
    message: "not a good cat sex" }
  validates :birth_date, :color, :sex, :name, :description, presence: :true

  def age
    Date.today - self.birth_date
  end

  private

  def timeliness
    if self.birth_date > Date.today
      errors[:birth_date] << "cat cannot be born in the future!"
    end
  end

end