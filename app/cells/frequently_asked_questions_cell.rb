class FrequentlyAskedQuestionsCell < Cell::ViewModel
  include Cell::Slim

  def show
    @section_count = section_count
    render
  end

  def section section_id
    @section_number = section_id
    @question_count = question_count section_id
    render
  end

  def question section_id, question_id
    link_options = link_options_hash section_id, question_id
    @anchor = I18n.exists?(".section_#{section_id}.question_#{question_id}.anchor", :de) ? I18n.t(".section_#{section_id}.question_#{question_id}.anchor") : ''
    @question_text = I18n.t(".section_#{section_id}.question_#{question_id}.question")
    @answer_text = I18n.t ".section_#{section_id}.question_#{question_id}.answer", link_options
    render
  end

  private

  def section_count
    count = 1
    while I18n.exists?(".section_#{count}", :de) do
      count += 1
    end
    count
  end

  def question_count section_id
    count = 1
    while I18n.exists?(".section_#{section_id}.question_#{count}", :de) do
      count += 1
    end
    count
  end

  def link_options_hash index, q_id
    l_id = 1
    options_hash = {}
    while I18n.exists?(".section_#{index}.question_#{q_id}.link_#{l_id}.var", :de) do
      var = I18n.t(".section_#{index}.question_#{q_id}.link_#{l_id}.var").to_sym
      name = I18n.t(".section_#{index}.question_#{q_id}.link_#{l_id}.name")
      url = I18n.t(".section_#{index}.question_#{q_id}.link_#{l_id}.url")
      target = I18n.exists?(".section_#{index}.question_#{q_id}.link_#{l_id}.target", :de) ? I18n.t(".section_#{index}.question_#{q_id}.link_#{l_id}.target") : ''
      klass = I18n.exists?(".section_#{index}.question_#{q_id}.link_#{l_id}.class", :de) ? I18n.t(".section_#{index}.question_#{q_id}.link_#{l_id}.class") : ''
      options_hash[var] = link_to(name, url, target: target, class: klass)
      l_id += 1
    end
    options_hash
  end

end
