class FrequentlyAskedQuestionsCell < Cell::ViewModel
  include Cell::Slim

  def show
    @section_ids = (1..section_count - 1).to_a
    render
  end

  def section section_id
    @anchor = t_exists?("section_#{section_id}.anchor") ? t("section_#{section_id}.anchor") : ''
    @section_id = section_id
    @question_ids = (1..question_count(section_id) - 1).to_a
    render
  end

  def question s_id, q_id
    link_options = link_options_hash s_id, q_id
    question_hash = t "section_#{s_id}.question_#{q_id}"
    @anchor = question_hash[:anchor] ? question_hash[:anchor] : ''
    @question = question_hash[:question]
    @answer = t "section_#{s_id}.question_#{q_id}.answer", link_options
    render
  end

  private

  def section_count
    count = 1
    count += 1 while t_exists?("section_#{count}")
    count
  end

  def question_count section_id
    count = 1
    count += 1 while t_exists?("section_#{section_id}.question_#{count}.question")
    count
  end

  def link_options_hash index, q_id
    l_id = 1
    options_hash = {}
    while t_exists?("section_#{index}.question_#{q_id}.link_#{l_id}.var")
      link_hash = t("section_#{index}.question_#{q_id}.link_#{l_id}")
      target = link_hash[:target] ? link_hash[:target] : ''
      klass = link_hash[:class] ? link_hash[:class] : ''
      options_hash[link_hash[:var].to_sym] =
        link_to(link_hash[:name], link_hash[:url], target: target, class: klass)
      l_id += 1
    end
    options_hash
  end

  # Helper method to load translation from correct path
  def t locator, *args
    I18n.t("cells.faq.#{locator}", I18n.locale, *args)
  end

  # Helper method to check for existence of translation in correct path
  def t_exists? locator
    I18n.exists?("cells.faq.#{locator}", I18n.locale) &&
      I18n.t("cells.faq.#{locator}", I18n.locale) != 'NOTRANSLATE'
  end
end
