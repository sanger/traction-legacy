# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'WorkOrders', type: :feature do
  include SequencescapeWebmockStubs

  before(:all) do
    create :gridion_pipeline
  end

  let!(:work_order) { create(:gridion_work_order_ready_for_sequencing) }
  let!(:aliquot) { work_order.aliquot }
  let!(:pipeline) { Pipeline.first }
  let!(:qc) { pipeline.find_process_step('qc') }
  let!(:library_preparation) { pipeline.find_process_step('library_preparation') }

  scenario 'Successfully edit work order' do
    stub_updates

    visit pipeline_work_order_path(pipeline, work_order)

    click_on 'Edit qc step'

    fill_in "metadata_items_attributes[#{qc.metadata_fields[0].id}]", with: '' # conc
    fill_in "metadata_items_attributes[#{qc.metadata_fields[1].id}]", with: '150' # fragment_size
    select 'proceed', from: "metadata_items_attributes[#{qc.metadata_fields[2].id}]" # state
    click_on 'Update Lab event'
    expect(page.text).to match('error prohibited this record from being saved')

    fill_in "metadata_items_attributes[#{qc.metadata_fields[0].id}]", with: '2.0' # conc
    click_on 'Update Lab event'
    expect(page).to have_content('qc step was successfully edited')
  end
end
