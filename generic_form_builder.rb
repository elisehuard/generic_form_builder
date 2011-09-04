class GenericFormBuilder < ActionView::Helpers::FormBuilder
  include ActionView::Helpers::TagHelper, ActionView::Helpers::UrlHelper

  %w[
    text_field
    password_field
    text_area
    email_field
    file_field
  ].each do |method|
    define_method(method.to_sym) do |field, options, *args|
      options ||= {:label => field.to_s.humanize}
      note   = content_tag(:span, options[:note], :class => 'note') if options[:note]
      button = ' '+content_tag(:button, content_tag(:span, options[:button])) if options[:button]
      errors = ' '+@object.errors[field].join(' and ') if @object.errors[field].any?
      content_tag(:p, label(field, "#{options[:label]}#{errors}") + note + super(field, *args) + button.html_safe)
    end
  end

  def collection_select(field, collection, value_method, name_method, options = {})
    label_text = options[:label] || field.to_s.humanize
    content_tag(:p, label(field, "#{label_text} #{@object.errors[field]}") + super(field, collection, value_method, name_method))
  end

  def check_box(field, options = {})
    label_text = options[:label] || field.to_s.humanize
    content_tag(:p, label(field, super + " #{label_text} #{@object.errors[field]}", :class => 'checkbox'))
  end

  def buttons(options = {})
    buttons  = content_tag(:button, content_tag(:span, options[:submit_text] || 'Save'), :type => 'submit')
    buttons << link_to('Cancel', options[:cancel_link], :class => 'cancel button') if options[:cancel_link]

    content_tag(:div, buttons, :class => 'actions')
  end

end