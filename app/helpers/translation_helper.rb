module TranslationHelper
  # render data as HTML string
  def translation_block automated, &block
    output = capture(&block)
    if automated
      automated_translation_wrap output
    else
      output
    end
  end

  private

  def automated_translation_wrap text
    <<-OUTPUT
      <div class="Automated-translation">
        <div class="Automated-translation__text"
             lang="#{I18n.locale}-x-mtfrom-de">
          #{text}
        </div>
        #{attribution_link}
      </div>
    OUTPUT
  end

  def attribution_link
    link_to(
      image_tag(image_path('poweredbygoogletranslate.png'),
                alt: 'powered by Google Translate'),
      'https://translate.google.com/',
      class: 'Automated-translation__attribution JS-tooltip'\
             ' JS-tooltip--from-title',
      title: t('shareds.show.google_translate_explanation')
    )
  end
end
