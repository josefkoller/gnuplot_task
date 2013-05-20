require 'rake'
require 'gnuplot'

class PlotTaskFactory
  def initialize params
    self.set_params params
  end
  def set_params params
    @task_name = params[:task_name]
    @task_description = params[:task_description]
    @filename = params[:filename]
    @filetype = (params[:filetype] or 'pdf')
    @label = params[:label]
    @xlabel = params[:xlabel]
    @ylabel = params[:ylabel]
    @data_sets = params[:data_sets]
  end

  def define_task
    task_body = proc {
      Gnuplot.open do |gnu_plot|
        Gnuplot::Plot.new( gnu_plot ) do |plot|
          plot.title @label
          filename = @filename
          filename  << ".#{@filetype}" unless filename.end_with? @filetype
          plot.output filename
          plot.terminal @filetype
          plot.xlabel @xlabel
          plot.ylabel @ylabel
          @data_sets.each do |data_set|
            plot.data << data_set
          end
        end
      end
      puts "plot file '#{@filename}' generated"
      system "open -a preview #{@filename}"
    }
    plot_task_params = [@task_name]
    plot_task = Rake::Task.define_task *plot_task_params, &task_body
    plot_task.add_description @task_description
  end
end


