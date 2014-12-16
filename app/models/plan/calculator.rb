class Plan::Calculator
  attr_accessor :plan, :result
  def initialize(plan)
    @plan = plan
    @result = Hash.new
  end

  def plans
    plan.planezations.each do |planezation|
      process(planezation)
    end
    result
  end

  def process(planezation)
    treehash = planezation.item.tree
    if treehash.blank?
      treehash[planezation.item] = planezation.quantity
    else
      treehash.each do |key, value|
        treehash[key] = value * planezation.quantity
      end
    end
    result.merge!(treehash) do |key, oldval, newval|
      oldval + newval
    end
  end
end
