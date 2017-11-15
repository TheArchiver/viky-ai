class Interpretation < ApplicationRecord
  Locales = %w[en-US fr-FR].sort.freeze

  belongs_to :intent

  validates :expression, presence: true
  validates :locale, inclusion: { in: self::Locales }, presence: true

  after_save do
    Nlp::Package.new(intent.agent).push
  end

  after_destroy do
    Nlp::Package.new(intent.agent).push
  end

end
