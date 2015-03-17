module PlansHelper
  def plan_progress_for(progress)
    content_tag :div, class: :progress do
      content_tag :div, class: 'progress-bar', 'aria-valuenow' => progress, 'aria-valuemin' => '0', 'aria-valuemax' => '100', style: "width: #{progress}%;" do
        "#{progress.to_i} %"
      end
    end
  end
end
