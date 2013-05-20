require 'rspec'
require __FILE__.gsub('_spec','').gsub('spec','lib')

describe PlotTaskFactory do
  it "needs parameters" do
    expect { PlotTaskFactory.new }.to raise_error
  end
  it "plots the given data set" do
    x = 1..100
    y = 3..300
    data_set = Gnuplot::DataSet.new( [x, y] ) do |actual_data_set|
      actual_data_set.with = "linespoints"
      actual_data_set.title = "line1"
    end
    factory = PlotTaskFactory.new \
      :task_name=>'test_task',
      :filename=>'plot_test',
      :label=>'test label',
      :xlabel=>'strain [m]',
      :ylabel=>'stress [Pa]',
      :data_sets=>[data_set]
    factory.define_task

    Rake::Task["test_task"].invoke
  end
end
