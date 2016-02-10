class FrequentlyAskedQuestionsCell < Cell::ViewModel
  include Cell::Slim

  def show
    @section_ids = (1..section_count - 1).to_a
    render
  end

  def section section_id
    @section_id = section_id
    @question_ids = (1..question_count(section_id) - 1).to_a
    render
  end

  def question s_id, q_id
    link_options = link_options_hash s_id, q_id
    question_hash = I18n.t ".section_#{s_id}.question_#{q_id}"
    @anchor = question_hash[:anchor] ? question_hash[:anchor] : ''
    @question = question_hash[:question]
    @answer = I18n.t ".section_#{s_id}.question_#{q_id}.answer", link_options
    render
  end

  private

  def section_count
    count = 1
    count += 1 while I18n.exists?(".section_#{count}", I18n.locale)
    count
  end

  def question_count section_id
    count = 1
    count += 1 while I18n.exists?(".section_#{section_id}.question_#{count}",
                                  I18n.locale)
    count
  end

  def link_options_hash index, q_id
    l_id = 1
    options_hash = {}
    while I18n.exists?(".section_#{index}.question_#{q_id}.link_#{l_id}.var",
                       I18n.locale)
      link_hash = I18n.t(".section_#{index}.question_#{q_id}.link_#{l_id}")
      target = link_hash[:target] ? link_hash[:target] : ''
      klass = link_hash[:class] ? link_hash[:class] : ''
      options_hash[link_hash[:var].to_sym] =
        link_to(link_hash[:name], link_hash[:url], target: target, class: klass)
      l_id += 1
    end
    options_hash
  end
end
