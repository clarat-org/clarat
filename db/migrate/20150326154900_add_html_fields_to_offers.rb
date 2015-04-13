class AddHtmlFieldsToOffers < ActiveRecord::Migration
  def up
    add_column :offers, :description_html, :text, limit: 550
    add_column :offers, :next_steps_html, :text, limit: 600

    Offer.find_each do |offer|
      offer.update_column(
        :description_html, MarkdownRenderer.render(offer.description)
      )
      offer.update_column(
        :next_steps_html, MarkdownRenderer.render(offer.next_steps)
      )
    end
  end

  def down
    remove_column :offers, :description_html
    remove_column :offers, :next_steps_html
  end
end
