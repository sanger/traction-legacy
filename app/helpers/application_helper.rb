# frozen_string_literal: true

module ApplicationHelper

  def current_year
    @current_year ||= Date.today.year
  end

  def editable_work_order_path(work_order)
    send("edit_#{work_order.next_state}_path", work_order)
  end
end
