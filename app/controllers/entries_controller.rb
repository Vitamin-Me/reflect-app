include VerseContextHelper

class EntriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_entry, only: %i[show edit update destroy]

  def index
    @entry = current_user.entries.new
    @entries = current_user.entries.order(created_at: :desc)
  end

  def new
    @entry = current_user.entries.new
    @entries = current_user.entries.order(created_at: :desc)
  end

  require 'net/http'
  require 'json'

def current_verse
  verses = ["John 1:14", "Romans 8:28", "Psalm 23:1", "Proverbs 3:5", "Isaiah 40:31"]
  reference = verses[Date.today.yday % verses.size]

  begin
    uri = URI("https://bible-api.com/#{ERB::Util.url_encode(reference)}")
    response = Net::HTTP.get(uri)
    data = JSON.parse(response)

    {
      reference: data["reference"],
      text: data["text"],
      translation: data["translation_name"]
    }
  rescue StandardError => e
    Rails.logger.error("Bible API failed: #{e.message}")
    # fallback so app never crashes
    {
      reference: reference,
      text: "Unable to load verse text at this time.",
      translation: "Unknown"
    }
  end
end
  helper_method :current_verse

  def current_verse_text
    "For all have sinned and fall short of the glory of God."
  end
  helper_method :current_verse_text
  
  def create
    @entry = current_user.entries.new(entry_params)
    @entry.title = current_verse[:reference] 
    @entry.verse_text = current_verse_text
    @entry.date = Date.today  # automatically set today’s date
    if @entry.save
      redirect_to entries_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @entry.update(entry_params)
      redirect_to @entry, notice: "Entry was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @entry.destroy!
    redirect_to entries_path, notice: "Entry was successfully destroyed."
  end

  private

  def set_entry
    @entry = current_user.entries.find(params[:id])
  end

  def entry_params
    params.require(:entry).permit(:content)
  end
end