class EventPolicy < ApplicationPolicy
  def manage?
    user.is_a?(EventOrganizer) && record.event_organizer_id == user.id
  end

  def create?
    user.is_a?(EventOrganizer)
  end

  def update?
    manage?
  end

  def destroy?
    manage?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end 