require 'rails_helper'

describe 'Wecome Page' do
  it 'has welcome sign and link to login' do
    visit '/'
    expect(page).to have_content('Welcome!')
    expect(page).to have_link('Sign in with Github')
  end
end
