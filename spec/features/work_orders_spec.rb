# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'WorkOrders', type: :feature do
  include SequencescapeWebmockStubs

  before(:all) do
    create :gridion_pipeline
  end

  let!(:work_orders)  { create_list(:gridion_work_order, 5) }
  let!(:work_order)   { work_orders.first }
  let!(:pipeline) { Pipeline.first }
  let!(:qc) { pipeline.find_process_step('qc') }
  let!(:library_preparation) { pipeline.find_process_step('library_preparation') }

  scenario 'Successfully QC and lib prep a work order' do
    stub_updates

    visit pipeline_work_orders_path(pipeline)
    click_on 'Qc'

    within("#work_order_#{work_order.id}") do
      click_link 'qc'
    end

    fill_in 'metadata_items_attributes[concentration]', with: '2.0'
    fill_in 'metadata_items_attributes[fragment_size]', with: '150'
    select 'proceed', from: 'metadata_items_attributes[qc_state]'
    click_on 'Create Lab event'

    expect(page).to have_content('qc step was successfully recorded')

    within("#work_order_#{work_order.id}") do
      click_link 'library_preparation'
    end

    fill_in 'metadata_items_attributes[volume]', with: '10'
    fill_in 'metadata_items_attributes[kit_number]', with: '123'
    click_on 'Create Lab event'

    expect(page).to have_content('library_preparation step was successfully recorded')
  end

  scenario 'QC a work order with invalid attributes' do
    visit pipeline_work_orders_path(pipeline)
    click_on 'Qc'

    within("#work_order_#{work_order.id}") do
      click_link 'qc'
    end

    fill_in 'metadata_items_attributes[concentration]', with: '2.0'
    select 'proceed', from: 'metadata_items_attributes[qc_state]'
    click_on 'Create Lab event'
    expect(page.text).to match('error prohibited this record from being saved')
  end

  scenario 'Invalid Library preparation' do
    stub_updates

    visit pipeline_work_orders_path(pipeline)
    click_on 'Qc'

    within("#work_order_#{work_order.id}") do
      click_link 'qc'
    end

    fill_in 'metadata_items_attributes[concentration]', with: '2.0'
    fill_in 'metadata_items_attributes[fragment_size]', with: '150'
    select 'proceed', from: 'metadata_items_attributes[qc_state]'
    click_on 'Create Lab event'

    expect(page).to have_content('qc step was successfully recorded')

    within("#work_order_#{work_order.id}") do
      click_link 'library_preparation'
    end

    fill_in 'metadata_items_attributes[volume]', with: '10'
    click_on 'Create Lab event'

    expect(page.text).to match('error prohibited this record from being saved')
  end
end
