module Votable
  extend ActiveSupport::Concern

  def do_vote(value)
    value.positive? ? rating_up : rating_down
    self.save!
  end

  private

  def rating_up
    self.rating += 1
  end

  def rating_down
    self.rating -= 1
  end
end