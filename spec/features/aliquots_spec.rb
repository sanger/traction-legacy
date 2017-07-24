# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Aliquots', type: :feature do

  scenario 'QC an aliquot' do
    aliquot = create(:aliquot)
    aliquot_after_qc = build(:aliquot_after_qc)

    visit edit_aliquot_path(aliquot)

    fill_in 'Concentration', with: aliquot_after_qc.concentration
    fill_in 'Fragment size', with: aliquot_after_qc.fragment_size
    select aliquot_after_qc.qc_state, from: 'QC state'
    click_button 'Update Aliquot'

    expect(page).to have_content('Aliquot successfully updated')
    expect(aliquot.reload).to be_proceed
  end
end
