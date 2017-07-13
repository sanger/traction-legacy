require "rails_helper"

RSpec.feature "Samples", type: :feature do 

  let!(:samples) { create_list(:sample, 5) }

  scenario 'List all samples' do
    visit samples_path
    samples.each do |sample|
      expect(page).to have_content(sample.name)
    end
  end

  scenario 'QC a sample' do
    sample_info = build(:sample_after_qc)
    sample = samples.first

    visit samples_path
    within("#sample_#{sample.id}") do
      click_link 'Edit'
    end

    fill_in 'Concentration', with: sample_info.concentration
    fill_in 'Fragment size', with: sample_info.fragment_size
    select sample_info.qc_state, from: 'QC state'
    click_button 'Update Sample'

    expect(page).to have_content('Sample successfully updated')
    expect(sample.reload).to be_proceed
  end
end