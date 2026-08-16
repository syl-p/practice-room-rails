module CurrentPractice
  extend ActiveSupport::Concern
  included do
    class_attribute :practice_id_param, instance_accessor: :false, default: :id
    before_action :set_practice
  end

  class_methods do
    def set_practice_id_param(param)
      self.practice_id_param = param
    end
  end

  private
  def set_practice
    @practice = Practice.find(params[self.class.practice_id_param])
  end

  def set_stats
    service = Practices::PracticeEntriesService.new(
      user: Current.user,
      practice_id: @practice.id,
      start_at: Date.today.beginning_of_day,
      end_at: Date.today.end_of_day
    )

    @stats = {
      total_duration: service.total_duration,
      activities_count: service.activities_count
    }
  end
end
