# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'WorkOrders', type: :feature do
  let!(:work_orders)  { create_list(:work_order, 5) }
  let!(:work_order)   { work_orders.first }

  scenario 'Successfully QC a work order' do
    aliquot = build(:aliquot_after_qc)

    visit work_orders_path

    within("#work_order_#{work_order.id}") do
      click_link 'Edit'
    end

    visit edit_work_order_path(work_order)

    fill_in 'Concentration', with: aliquot.concentration
    fill_in 'Fragment size', with: aliquot.fragment_size
    select aliquot.qc_state, from: 'QC state'
    click_button 'Update Work order'

    expect(page).to have_content('Work Order successfully updated')
    work_order.reload
    expect(work_order.aliquot).to be_proceed
    expect(work_order).to be_qc
  end

  # scenario 'QC a work order with invalid attributes' do
  #   aliquot = build(:aliquot_after_qc)

  #   visit work_orders_path

  #   save_and_open_page

  #   within("#work_order_#{work_order.id}") do
  #     click_link "Edit"
  #   end

  #   visit edit_work_order_path(work_order)

  #   fill_in 'Concentration', with: aliquot.concentration
  #   fill_in 'Fragment size', with: aliquot.fragment_size
  #   select aliquot.qc_state, from: 'QC state'
  #   click_button 'Update Work order'

  #   expect(page).to have_content('Work Order successfully updated')
  #   work_order.reload
  #   expect(work_order.aliquot).to be_proceed
  #   expect(work_order).to be_qc
  # end

  scenario 'Successful Library preparation' do
    work_order.qc!
    library = build(:library)

    visit edit_work_order_path(work_order)

    fill_in 'Volume', with: library.volume
    fill_in 'Kit number', with: library.kit_number
    click_button 'Update Work order'

    expect(page).to have_content('Work Order successfully updated')
    work_order.reload
    expect(work_order.library).to be_present
    expect(work_order).to be_library_preparation
  end

  scenario 'Library preparation with invalid attributes' do
    work_order.qc!
    library = build(:library)

    visit edit_work_order_path(work_order)

    fill_in 'Volume', with: library.volume
    click_button 'Update Work order'

    expect(page.text).to match('error prohibited this record from being saved')
  end
end
