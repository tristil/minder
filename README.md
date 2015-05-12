## What is it?

This is a CLI-based tool that combines the best of several different
productivity methodologies.

At present it has these features:

- A timer to help with keeping to the [Pomodoro
  Technique](http://pomodorotechnique.com/) rhythm of 4 25 minute work periods
  with five minute breaks, followed by a long 15 minute break. You hear the
  soothing sounds of a "pomodoro" kitchen timer at the beginning and end of a
  break.
- A todo log that allows starting, unstarting and completing a task.
- Stores a simple text log of task and pomodoro activity.

Plans for the future include:

- Filtering by GTD-style labels (like @context, +project, and #tag)
- Integration with a website blacklist tool like
  [SelfControl](https://github.com/SelfControlApp/selfcontrol/).
- Keeping track of the number of pomodoros performed during a day.
- Desktop notifications for Linux and MacOS
- Prompts to summarize plans for the day and day's end progress.

Audio files are from https://github.com/niftylettuce/pomodoro-timer

## Usage

There are three sections. You can switch between sections by pressing Tab. The
commands for each section only work when the section is focused.

- The Pomodoro timer section. Press space to begin the next period. Press 'e'
  to edit the whole tasks list in your `$EDITOR`.
- The Tasks section. This section disappears during a Pomodoro period to avoid
  distraction.
  - Press 'd' to mark a task as done.
  - Press 'x' to delete a task.
  - Press 's' to start a task.
  - Press 'u' to un-start a task.
- The Quick Add Task section. Enter text here to add a task to the tasks list
  at any time.

## License

MIT License, see LICENSE.txt
