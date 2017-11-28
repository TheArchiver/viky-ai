require 'application_system_test_case'

class InterpretationsTest < ApplicationSystemTestCase


  test 'Create an interpretation' do
    go_to_agents_index
    assert page.has_text?('admin/weather')
    click_link 'My awesome weather bot admin/weather'
    assert page.has_text?('weather_greeting')

    click_link 'weather_greeting'
    assert page.has_text?('Add')

    assert_equal "1", first('#current-locale-tab-badge').text

    first('trix-editor').click.set('Good morning')
    click_button 'Add'
    assert page.has_text?('Good morning')

    assert_equal "2", first('#current-locale-tab-badge').text
  end


  test 'Errors on interpretation creation' do
    go_to_agents_index
    assert page.has_text?('admin/weather')
    click_link 'My awesome weather bot admin/weather'
    assert page.has_text?('weather_greeting')

    click_link 'weather_greeting'
    assert page.has_text?('Add')

    assert_equal "1", first('#current-locale-tab-badge').text

    first('trix-editor').click.set('')
    click_button 'Add'
    assert page.has_text?('Expression can\'t be blank')

    assert_equal "1", first('#current-locale-tab-badge').text
  end


  test 'Update an intent' do
    go_to_agents_index
    assert page.has_text?('admin/weather')
    click_link 'My awesome weather bot admin/weather'
    assert page.has_text?('weather_greeting')

    click_link 'weather_greeting'
    click_link 'fr-FR'
    assert page.has_link?('Bonjour tout le monde')

    assert_equal '1', first('#current-locale-tab-badge').text

    within('#interpretations-list') do
      click_link 'Bonjour tout le monde'
      assert page.has_text?('Cancel')
      first('trix-editor').click.set('Salut à tous')
      check('interpretation[keep_order]')
      check('interpretation[glued]')
      fill_in_editor_field '10'
      click_button 'Update'
    end

    assert page.has_link?('Salut à tous')
    assert_equal '1', first('#current-locale-tab-badge').text
  end


  test 'Delete an interpretation' do
    go_to_agents_index
    assert page.has_text?('admin/weather')
    click_link 'My awesome weather bot admin/weather'
    assert page.has_text?('weather_greeting')

    click_link 'weather_greeting'
    assert page.has_link?('Hello world')

    assert_equal "1", first('#current-locale-tab-badge').text

    within('#interpretations-list') do
      click_link 'Hello world'
      assert page.has_text?('Cancel')
      all('a').last.click
    end
    assert page.has_no_link?('Cancel')
    assert_equal "0", first('#current-locale-tab-badge').text
  end


  private

    def fill_in_editor_field(text)
      within '.CodeMirror' do
        # Click makes CodeMirror element active:
        current_scope.click
        # Find the hidden textarea:
        field = current_scope.find('textarea', visible: false)
        # Mimic user typing the text:
        field.send_keys text
      end
    end
end
