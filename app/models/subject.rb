class Subject < ActiveRecord::Base


  has_one :information, as: :infoable, dependent: :destroy
  belongs_to :owner, polymorphic: true
  has_many :informations, class_name: "Information"

  after_create :create_information

  def summary
    self.description
  end

  private

  def create_information
    Information.create infoable: self
  end

end
