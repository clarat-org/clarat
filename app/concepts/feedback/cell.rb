class Feedback::Cell < Cell::Concept
  builds do |model, options|
    if options[:type] == :report_button
      ReportButtonCell
    else
      FormCell
    end
  end

  class FormCell < self
    # Dependencies for SimpleForm
    include ActionView::RecordIdentifier
    include ActionView::Helpers::FormHelper
    include SimpleForm::ActionViewExtensions::FormHelper
    # /Dependencies for SimpleForm

    property :reporting

    def show
      render :form
    end

    private

    def t key # waiting for https://github.com/apotonick/cells/issues/272
      I18n.t "feedbacks.form#{key}"
    end
  end

  class ReportButtonCell < self
    def show
      render :report_button
    end

    private

    def t key # waiting for https://github.com/apotonick/cells/issues/272
      I18n.t "feedbacks.report_button#{key}"
    end

    def report_link &block
      link_to new_feedback_path,
              {class: 'offer-contribute js-report-overlay_open'},
              &block
    end


    # Modal with content block
    def modal_for selector, options = {}, &block
      concept 'modal/cell',
              OpenStruct.new(selector: selector, options: options, block: block)
    end
  end
end
