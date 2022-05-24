=begin
Valentina is using a new task manager program she wrote. When interacting with her task manager, an error is raised that surprises her. Can you find the bug and fix it?

=> fix

The problem is that in the `display_high_priority_tasks` method, the first
line invokes a local variable `tasks`, which has not been assigned, and its
value is nil. Ruby inteprets this as local variable assignment and not a
setter because it is not called with `self.` prepended.

Correcting this by adding `self.` would not be a good idea, because we
wouldn't want to permanently mutate @tasks with the return value of the
select statement. The best option is to rename the local variable so it does
not shadow the getter method name.

=end

class TaskManager
  attr_reader :owner
  attr_accessor :tasks

  def initialize(owner)
    @owner = owner
    @tasks = []
  end

  def add_task(name, priority=:normal)
    task = Task.new(name, priority)
    tasks.push(task)
  end

  def complete_task(task_name)
    completed_task = nil

    tasks.each do |task|
      completed_task = task if task.name == task_name
    end

    if completed_task
      tasks.delete(completed_task)
      puts "Task '#{completed_task.name}' complete! Removed from list."
    else
      puts "Task not found."
    end
  end

  def display_all_tasks
    display(tasks)
  end

  def display_high_priority_tasks
    important_tasks = tasks.select do |task|
      task.priority == :high
    end

    display(important_tasks)
  end

  private

  def display(tasks)
    puts "--------"
    tasks.each do |task|
      puts task
    end
    puts "--------"
  end
end

class Task
  attr_accessor :name, :priority

  def initialize(name, priority=:normal)
    @name = name
    @priority = priority
  end

  def to_s
    "[" + sprintf("%-6s", priority) + "] #{name}"
  end
end

valentinas_tasks = TaskManager.new('Valentina')

valentinas_tasks.add_task('pay bills', :high)
valentinas_tasks.add_task('read OOP book')
valentinas_tasks.add_task('practice Ruby')
valentinas_tasks.add_task('run 5k', :low)

valentinas_tasks.complete_task('read OOP book')

valentinas_tasks.display_all_tasks
valentinas_tasks.display_high_priority_tasks