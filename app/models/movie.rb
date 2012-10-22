class Movie < ActiveRecord::Base

  def self.getratings
    return ['G', 'PG', 'PG-13', 'R']
  end
end
