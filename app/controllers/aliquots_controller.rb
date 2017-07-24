# frozen_string_literal: true

# Aliquots Controller
class AliquotsController < ApplicationController

  attr_reader :aliquot

  before_action :set_aliquot, only: [:edit, :show]

  def show; end

  def edit; end

  def update
    aliquot = current_resource
    if aliquot.update_attributes(aliquot_params)
      redirect_to aliquot_path(aliquot), notice: 'Aliquot successfully updated'
    else
      render :edit
    end
  end

  protected

  def set_aliquot
    @aliquot ||= current_resource
  end

  def current_resource
    @current_resource = Aliquot.find(params[:id]) if params[:id].present?
  end

  def aliquot_params
    params.require(:aliquot).permit(:concentration, :fragment_size, :qc_state)
  end

  helper_method :aliquot

end
