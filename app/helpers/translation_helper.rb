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

  def autotranslation_attr automated = true
    return {} unless automated
    { lang: "#{I18n.locale}-x-mtfrom-de" }
  end

  def automation_warning automated = true
    return unless automated
    '<div class="Automated-translation__wrapper">' +
      image_tag(
        image_path('banner--translated-by-google.svg'),
        alt: 'warning',
        class: 'Automated-translation__warning JS-tooltip '\
               'JS-tooltip--from-title',
        title: t('shareds.show.google_translate_explanation')
      ) +
      '</div>'
  end

  private

  def automated_translation_wrap text
    <<-OUTPUT
      <div class="Automated-translation" lang="#{autotranslation_attr[:lang]}">
        #{text}
      </div>
    OUTPUT
  end
end
