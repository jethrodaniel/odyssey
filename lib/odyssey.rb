require "odyssey/error"

# Odyssey is a extensible text analysis gem that supports various readability
# scores, and other metrics, such as syllable and word count.
#
module Odyssey
  # Builtin formulas.
  FORMULAS = %w[Ari ColemanLiau FleschKincaidGl FleschKincaidRe GunningFog Smog]

  # Default formula for {analyze}.
  DEFAULT_FORMULA = 'FleschKincaidRe'

  # Analyze a string with a given formula.
  #
  # The formula defaults to {DEFAULT_FORMULA}. Returns the score, or if
  # `all_stats` is true, various scores/metrics for the text.
  #
  # @example
  #  Odyssey.analyze "Shall I compare thee to a summer's day?"         #=> 93.0
  #  Odyssey.analyze "Thou art more lovely and more temperate.", 'Ari' #=> 4.3
  #  Odyssey.analyze "A horse, a horse, my kingdom for a horse!", nil, true
  #  #=> {"string_length"=>41,
  #       "letter_count"=>30,
  #       "syllable_count"=>10,
  #       "word_count"=>9,
  #       "sentence_count"=>1,
  #       "average_words_per_sentence"=>9.0,
  #       "average_syllables_per_word"=>1.1111111111111112,
  #       "name"=>"Flesch-Kincaid Reading Ease",
  #       "formula"=>#<FleschKincaidRe:0x000055f35d9c2470>,
  #       "score"=>103.7,
  #       "score_by_sentence"=>
  #        [#<struct
  #          score=103.7,
  #          sentence="A horse, a horse, my kingdom for a horse!">]}
  #
  # @param text [String] text to analyze
  # @param formula_name [String] the formula to use
  # @return [Number] the score of the formula on the text (if `all_stats` is false)
  # @return [Hash<String>] various scores for the text (if `all_stats` is true)
  #
  def self.analyze(text, formula_name = DEFAULT_FORMULA, all_stats = false)
    formula_name ||= DEFAULT_FORMULA

    @engine = Odyssey::Engine.new(formula_name)
    score = @engine.score(text)

    return @engine.get_stats if all_stats

    score
  end

  # Analyze text with multiple formulas.
  #
  # @param (see #analyze)
  # @param formula_names [Array<String>] formulas to use
  # @raise [ArgumentError] if no formula_names are provided
  # @see analyze
  #
  def self.analyze_multi(text, formula_names, all_stats = false)
    raise Odyssey::ArgumentError, "You must supply at least one formula" if formula_names.empty?

    scores = {}
    @engine = Odyssey::Engine.new(formula_names[0])
    scores[formula_names[0]] = @engine.score(text)

    formula_names.drop(1).each do |formula_name|
      @engine.update_formula(formula_name)
      scores[formula_name] = @engine.score("", false)
    end

    return scores unless all_stats

    all_stats = @engine.get_stats(false)
    all_stats['scores'] = scores
    all_stats
  end

  # Analyze text with all {FORMULAS}.
  #
  # @param text [String] text to analyze
  # @see analyze
  #
  def self.analyze_all(text)
    analyze_multi text, FORMULAS, true
  end

  # Attempt to call {analyze} for a formula `'FormulaName'` via
  # `Odyssey.formula_name`, forwarding arguments.
  #
  # @param method_name [Symbol]
  # @param args [Array<Any>]
  #
  def self.method_missing(method_name, *args, &block)
    formula_class = method_name.to_s.split("_").map(&:capitalize).join
    super unless Object.const_defined? formula_class
    analyze(args[0], formula_class, args[1] || false)
  end
end

require 'odyssey/engine'
require 'odyssey/refinements'
require 'odyssey/formulas/formula'

require 'odyssey/formulas/ari'
require 'odyssey/formulas/coleman_liau'
require 'odyssey/formulas/fake_formula'
require 'odyssey/formulas/flesch_kincaid_gl'
require 'odyssey/formulas/flesch_kincaid_re'
require 'odyssey/formulas/gunning_fog'
require 'odyssey/formulas/smog'
