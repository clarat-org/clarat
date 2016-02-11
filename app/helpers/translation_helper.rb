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
    image_tag(
      image_path('ico_triangle.svg'),
      alt: 'warning',
      class: 'Automated-translation__warning JS-tooltip JS-tooltip--from-title',
      title: t('shareds.show.google_translate_explanation')
    )
  end

  private

  def automated_translation_wrap text
    <<-OUTPUT
      <div class="Automated-translation">
        <div class="Automated-translation__text"
             lang="#{autotranslation_attr[:lang]}">
          #{text}
        </div>
      </div>
    OUTPUT
  end
end
