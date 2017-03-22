class Disease < ApplicationRecord

  default_scope {order("diseases.name ASC")}
  scope :order_by_id, -> (ord) {order("diseases.id #{ord}")}
  scope :order_by_name, -> (ord) {order("diseases.name #{ord}")}
  scope :order_by_created_at, -> (ord) {order("diseases.created_at #{ord}")}

  has_many :medical_record_by_diseases
  has_many :medical_records, through: :medical_record_by_diseases

  validates :name,:description, presence: true
  validates :name, length: {minimum: 3}
  validates :name, uniqueness: true
  validates :description, length: { in: 10...250 }

  def self.load_diseases(**args)
    includes(medical_records: [:user])
      .paginate(:page => args[:page] || 1, :per_page => args[:per_page] || 10)
  end

  def self.disease_by_id(id)
    includes(medical_records: [:user])
      .find_by_id(:id)
  end

  def self.diseases_by_name(name,**args)
    load_diseases(args)
      .where("diseases.name LIKE ?", "#{name.downcase}%")
  end

  def self.diseases_by_ids(ids, **args)
    load_diseases(args)
      .where(diseases: {id: ids})
  end

  def self.diseases_by_not_ids(ids,**args)
    load_diseases(args)
      .where.not(diseases:{id: ids})
  end

  def self.diseases_with_medical_records(**args)
    joins(:medical_records).select('diseases.*')
      .group("diseases.id")
      .paginate(:page => args[:page] || 1, :per_page => args[:per_page] || 10)
      .reorder("count(medical_records.id)")
  end

  def self.diseases_with_medical_records_by_id(id, **args)
    load_diseases(args)
      .where(medical_record_by_diseases: {medical_record_id: id})
  end

  def self.diseases_by_user(user,**args)
    joins(medical_records: :user)
      .group("diseases.id")
      .where(users: {
          id: user
      }).paginate(:page => args[:page] || 1,:per_page => args[:per_page])
  end

end
