require_relative '../test_helper'

describe EmailsController do
  let(:email) { Email.create! address: 'a@b.c', security_code: 'correct' }

  describe '#subscribe' do
    before { email.update_column :aasm_state, 'informed' }

    it 'must work with a correct security code' do
      get :subscribe, id: email.id, security_code: email.security_code,
                      locale: 'de'
      assert_redirected_to :root
      assert_equal(
        I18n.t('emails.subscribe.success_html',
               unsubscribe_href:
                 "/emails/1/unsubscribe/#{email.reload.security_code}"),
        flash[:success])
    end

    it 'wont work with an incorrect security code' do
      assert_raise(Pundit::NotAuthorizedError) do
        get :subscribe, id: email.id, security_code: 'incorrect', locale: 'de'
      end
    end
  end

  describe '#unsubscribe' do
    before { email.update_column :aasm_state, 'subscribed' }

    it 'must work with a correct security code' do
      get :unsubscribe, id: email.id, security_code: email.security_code,
                        locale: 'de'
      assert_redirected_to :root
      assert_equal(
        I18n.t('emails.unsubscribe.success_html',
               subscribe_href: '/emails/1/subscribe/correct'),
        flash[:success])
    end

    it 'wont work with an incorrect security code' do
      assert_raise(Pundit::NotAuthorizedError) do
        get :unsubscribe, id: email.id, security_code: 'incorrect', locale: 'de'
      end
    end
  end

  describe '#offers_index' do
    it 'must work for an email in family' do
      get :offers_index, id: email.id, locale: 'de', section: 'family'
      assert_response 200
    end

    it 'must work for an email in refugees' do
      get :offers_index, id: email.id, locale: 'de', section: 'refugees'
      assert_response 200
    end
  end
end
