# frozen_string_literal: true

require 'test_helper'

feature 'FAQ display' do
  scenario 'FAQ has correct heading' do
    visit '/haeufige-fragen'
    page.must_have_content 'Häufige Fragen'
  end

  scenario 'FAQ contains all sections' do
    visit '/haeufige-fragen'
    page.must_have_content 'Wer, wie, was?'
    page.must_have_content 'Hast du Fragen zu deiner Suche?'
    page.must_have_content 'Hast du Fragen zur clarat-Sprache?'
    page.must_have_content 'Hast du Fragen zu clarat in verschiedenen Sprachen?'
    page.must_have_content 'Hast du Fragen als Mitarbeiter einer Organisation?'
  end

  scenario 'FAQ contains questions' do
    visit '/haeufige-fragen'
    page.must_have_content 'Was ist clarat?'
    page.must_have_content 'Wer findet bei clarat Hilfe?'
    page.must_have_content 'Auf welchen Sprachen gibt es clarat?'
    page.must_have_content 'Warum ist meine Organisation nicht bei clarat?'
    page.must_have_content(
      'Warum schreibt clarat immer in einer einfachen Sprache?'
    )
  end
end
