require 'spec_helper'

class CommandRun
  attr_accessor :stdout, :stderr, :exitstatus

  def initialize(args)
    out = StringIO.new
    err = StringIO.new

    $stdout = out
    $stderr = err

    begin
      GovukSeedCrawler::Cli.new(args).run
      @exitstatus = 0
    rescue SystemExit => e
      # Capture exit(n) value.
      @exitstatus = e.status
    end

    @stdout = out.string.strip
    @stderr = err.string.strip

    $stdout = STDOUT
    $stderr = STDERR
  end
end

describe GovukSeedCrawler::Cli do
  subject { CommandRun.new(args) }

  describe "normal usage" do
    context "when asked to display version" do
      let(:args) { %w{--version} }

      it "should not instantiate Seeder" do
        expect(GovukSeedCrawler::Seeder).not_to receive(:seed)
      end

      it "should print version and exit normally" do
        expect(subject.stdout).to eq(GovukSeedCrawler::VERSION)
        expect(subject.exitstatus).to eq(0)
      end
    end

    context "when asked to display help" do
      let(:args) { %w{--help} }

      it "should not instantiate Seeder" do
        expect(GovukSeedCrawler::Seeder).not_to receive(:seed)
      end

      it "should print usage and exit normally" do
        expect(subject.stderr).to match(/\AUsage: \S+ \[options\]\n/)
        expect(subject.exitstatus).to eq(0)
      end
    end
  end

  describe "incorrect usage" do
    shared_examples "print usage and exit abnormally" do |error|
      it "should not instantiate Seeder" do
        expect(GovukSeedCrawler::Seeder).not_to receive(:seed)
      end

      it "should print error message and usage" do
        expect(subject.stderr).to match(/\A\S+: #{error}\nUsage: \S+/)
      end

      it "should exit abnormally for incorrect usage" do
        expect(subject.exitstatus).to eq(2)
      end
    end

    context "when given an unrecognised argument" do
      let(:args) { %w{--this-is-garbage} }

      it_behaves_like "print usage and exit abnormally", "invalid option: --this-is-garbage"
    end
  end
end
