class User < ActiveRecord::Base
  ROLES = %i[top_manager manager worker].freeze

  extend Enumerize

  has_secure_password

  belongs_to :inviter, class_name: 'User'

  has_many :created_tasks, class_name: 'Task', foreign_key: :creator_id
  has_many :task_participations
  has_many :tasks, through: :task_participations

  validates :email, email: true, uniqueness: true

  enumerize :role, in: ROLES, default: :worker

  def guest?
    false
  end

  def to_s
    email
  end
end
