# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'WorkOrders', type: :feature do

  scenario 'QC a work order' do
    work_order = create(:work_order)
    aliquot_after_qc = build(:aliquot_after_qc)

    visit edit_work_order_path(work_order)

    fill_in 'Concentration', with: aliquot_after_qc.concentration
    fill_in 'Fragment size', with: aliquot_after_qc.fragment_size
    select aliquot_after_qc.qc_state, from: 'QC state'
    click_button 'Update Work order'

    expect(page).to have_content('Work Order successfully updated')
    work_order.reload
    expect(work_order.aliquot).to be_proceed
    expect(work_order).to be_qc
  end
end
