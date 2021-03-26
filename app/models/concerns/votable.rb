module Votable
  extend ActiveSupport::Concern

  def do_vote(value, current_user, cancel = false)
    transaction do
      if cancel
        value == "for" ? rating_down : rating_up
        current_user.vote(self).destroy
      else
        current_user.votes.create(votable: self, value: value)
        value == "for" ? rating_up : rating_down
      end

      self.save!
    end
  end

  private

  def rating_up
    self.rating += 1
  end

  def rating_down
    self.rating -= 1
  end
end