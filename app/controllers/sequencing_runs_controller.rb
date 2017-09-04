# frozen_string_literal: true

# SequencingRuns Controller
class SequencingRunsController < ApplicationController
  attr_reader :sequencing_runs, :sequencing_run

  before_action :set_sequencing_run, only: %i[show]
  before_action :sequencing_runs, only: %i[index]

  def index; end

  def new
    @sequencing_run = SequencingRunForm.new
  end

  def create
    @sequencing_run = SequencingRunForm.new
    if sequencing_run.submit(sequencing_run_params)
      redirect_to sequencing_run_path(sequencing_run), notice: 'Sequencing run successfully created'
    else
      render :new
    end
  end

  def edit
    @sequencing_run = SequencingRunForm.new(current_resource)
  end

  def update
    @sequencing_run = SequencingRunForm.new(current_resource)
    if sequencing_run.submit(sequencing_run_params)
      redirect_to sequencing_run_path(sequencing_run), notice: 'Sequencing run successfully updated'
    else
      render :edit
    end
  end

  def show; end

  protected

  def sequencing_runs
    @sequencing_runs = SequencingRun.by_date
  end

  def set_sequencing_run
    @sequencing_run ||= current_resource
  end

  def current_resource
    @current_resource = SequencingRun.includes(:flowcells).find(params[:id]) if params[:id].present?
  end

  def sequencing_run_params
    params.require(:sequencing_run).permit(:instrument_name, :state,
                                           flowcells_attributes:
                                           %i[id flowcell_id position work_order_id])
  end

  helper_method :sequencing_runs, :sequencing_run
end
