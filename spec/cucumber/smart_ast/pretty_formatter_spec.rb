require File.dirname(__FILE__) + '/../../spec_helper'
require 'cucumber/smart_ast/pretty_formatter'
require 'cucumber/smart_ast/builder'
require 'cucumber/smart_ast/features'
require 'gherkin'

module Cucumber
  module SmartAst
    describe PrettyFormatter do
      describe "when the features contain just a single empty scenario" do
        it "should print the same scenario" do
          io = StringIO.new
          formatter = PrettyFormatter.new(io)
          feature_content = <<-FEATURES
Feature: Feature Description

  Scenario: Scenario Description
          FEATURES
          
          features = load_features(feature_content)
          step_mother = StepMother.new
          features.execute(step_mother, [formatter])
          
          io.string.should == feature_content
        end
        
        def load_features(content)
          builder = Builder.new
          parser = ::Gherkin::Parser.new(builder, true, "root")
          lexer = ::Gherkin::I18nLexer.new(parser)
          lexer.scan(content)
          features = Features.new
          features << builder.ast
          features
        end
      end
    end
  end
end