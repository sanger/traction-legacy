# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'WorkOrders', type: :feature do
  include SequencescapeWebmockStubs

  let!(:work_orders)  { create_list(:work_order, 5) }
  let!(:work_order)   { work_orders.first }

  scenario 'Successfully QC a work order' do
    stub_updates

    aliquot = build(:aliquot_proceed)

    visit qcs_path

    within("#work_order_#{work_order.id}") do
      click_link 'qc'
    end

    fill_in 'Concentration', with: aliquot.concentration
    fill_in 'Fragment size', with: aliquot.fragment_size
    select aliquot.qc_state, from: 'QC state'
    click_button 'Update Work order'

    expect(page).to have_content('Work Order successfully updated')
  end

  scenario 'QC a work order with invalid attributes' do

    aliquot = build(:aliquot_proceed)

    visit work_orders_path

    within("#work_order_#{work_order.id}") do
      click_link 'qc'
    end

    fill_in 'Concentration', with: aliquot.concentration
    select aliquot.qc_state, from: 'QC state'
    click_button 'Update Work order'

    expect(page.text).to match('error prohibited this record from being saved')
  end

  scenario 'Successful Library preparation' do
    stub_updates

    work_order.qc!
    library = build(:library)

    visit library_preparations_path

    within("#work_order_#{work_order.id}") do
      click_link 'library preparation'
    end

    fill_in 'Volume', with: library.volume
    fill_in 'Kit number', with: library.kit_number
    click_button 'Update Work order'

    expect(page).to have_content('Work Order successfully updated')
  end

  scenario 'Invalid Library preparation' do

    work_order.qc!
    library = build(:library)

    visit work_orders_path

    within("#work_order_#{work_order.id}") do
      click_link 'library preparation'
    end

    fill_in 'Volume', with: library.volume
    click_button 'Update Work order'

    expect(page.text).to match('error prohibited this record from being saved')
  end
end
