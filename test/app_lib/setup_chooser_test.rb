#!/bin/bash ../test_wrapper.sh

require_relative './app_lib_test_base'

class SetupChooserTest < AppLibTestBase

  include SetupChooser

  def setup
    super
    set_katas_root(tmp_root + 'katas')
  end

  #- - - - - - - - - - - - - - - - - - - - - - -

  test '773616',
  'when id is given and katas[id].language exists then choose that language' do
    cmd = test_languages_names.map{ |name| name.split('-').join(', ') }
    test_languages_names.each_with_index do |language, n|
      kata = make_kata({ language:language, exercise:test_exercises_names.sample })
      assert_equal n, choose_language(cmd, kata.id, katas), language
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - -

  test 'D9C2F2',
  'when id is given and katas[id].exercise exists then choose that exercise' do
    test_exercises_names.each_with_index do |exercise, n|
      kata = make_kata({ language:test_languages_names.sample, exercise:exercise })
      assert_equal n, choose_exercise(test_exercises_names, kata.id, katas)
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - -

  test 'CD36CB',
  'when no id is given then choose random language' do
    assert_is_randomly_chosen_language(test_languages_names, id = nil, katas)
  end

  test '64576B',
  'when chooser is passed choices=[] and id=nil result is nil' do
    assert_nil choose_language([], nil, katas)
  end

  #- - - - - - - - - - - - - - - - - - - - - - -

  test '42D488',
  'when no id is given then choose random exercise' do
    assert_is_randomly_chosen_exercise(test_exercises_names, id = nil, katas)
  end

  #- - - - - - - - - - - - - - - - - - - - - - -

  test '41EB67',
  'when id is given but katas[id].nil? then choose random language' do
    id = unique_id
    kata = dojo.katas[id]
    assert_nil kata
    assert_is_randomly_chosen_language(test_languages_names, id, katas)
  end

  #- - - - - - - - - - - - - - - - - - - - - - -

  test '35A56C',
  'when id is given but katas[id].nil? then choose random exercise' do
    id = unique_id
    kata = dojo.katas[id]
    assert_nil kata
    assert_is_randomly_chosen_exercise(test_exercises_names, id, katas)
  end

  #- - - - - - - - - - - - - - - - - - - - - - -

  test '9671E1',
  'when id is given and _!_katas[id].language.exists? then choose random language' do
    test_languages_names.each do |unknown_language|
      languages = test_languages_names - [unknown_language]
      refute languages.include?(unknown_language)
      kata = make_kata({ language:unknown_language, exercise:test_exercises_names.sample })
      assert_is_randomly_chosen_language(languages, kata.id, katas)
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - -

  test '8D0F94',
  'when id is given and _!_katas[id].exercise.exists? then choose random exercise' do
    test_exercises_names.each do |unknown_exercise|
      exercises = test_exercises_names - [unknown_exercise]
      refute exercises.include?(unknown_exercise)
      kata = make_kata({ language:test_languages_names.sample, exercise:unknown_exercise })
      assert_is_randomly_chosen_exercise(exercises, kata.id, katas)
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - -

  private

  def assert_is_randomly_chosen_language(languages, id, katas)
    counts = {}
    (1..100).each do
      n = choose_language(languages, id, katas)
      counts[n] ||= 0
      counts[n] += 1
    end
    assert_equal languages.length, counts.length
  end

  #- - - - - - - - - - - - - - - - - - - - - - -

  def assert_is_randomly_chosen_exercise(exercises, id, katas)
    counts = {}
    (1..100).each do
      n = choose_exercise(exercises, id, katas)
      counts[n] ||= 0
      counts[n] += 1
    end
    assert_equal exercises.length, counts.length
  end

  #- - - - - - - - - - - - - - - - - - - - - - -

  def test_languages_names
    [ 'C#-NUnit',
      'C++ (g++)-GoogleTest',
      'Ruby-Test::Unit',
      'Java-JUnit'
    ].sort

  end

  #- - - - - - - - - - - - - - - - - - - - - - -

  def test_exercises_names
    ['Yatzy',
     'Roman_Numerals',
     'Leap_Years',
     'Fizz_Buzz',
     'Zeckendorf_Number'
    ].sort
  end

end
