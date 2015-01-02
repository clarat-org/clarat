$('#new_subscription').replaceWith(
  "<%= j render '/subscriptions/shared/new', subscription: Subscription.new %>"
);
$('body').prepend(
  "<%=
    j render 'layouts/partials/flash',
             type: 'success',
             content: I18n.t('flash.subscription.success')
  %>"
);
