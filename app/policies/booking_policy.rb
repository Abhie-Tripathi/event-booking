class BookingPolicy < ApplicationPolicy
  def show?
    user.is_a?(Customer) && record.customer_id == user.id
  end

  def create?
    user.is_a?(Customer)
  end

  def cancel?
    user.is_a?(Customer) && record.customer_id == user.id && record.status != 'cancelled'
  end

  class Scope < Scope
    def resolve
      scope.where(customer: user)
    end
  end
end 