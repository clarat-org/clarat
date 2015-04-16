class AddOpeningSpecificationHtmlToOffer < ActiveRecord::Migration
  def change
    add_column :offers, :opening_specification_html, :text

    Offer.find_each do |offer|
      if offer.opening_specification
        offer.update_column(
          :opening_specification_html,
          MarkdownRenderer.render(offer.opening_specification)
        )
      end
    end
  end
end
