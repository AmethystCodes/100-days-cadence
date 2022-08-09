import TaskTracker from 0x01

transaction(task: String) {

  prepare(acct: AuthAccount) {
    let myTaskList <- acct.load<@TaskTracker.TaskList>(from: /storage/MyTaskList) 
        ?? panic("Nothing lives at this path")
    myTaskList.addTask(task: task)
    acct.save(<- myTaskList, to: /storage/MyTaskList)
  }

  execute {}

}
