import TaskTracker from 0x01

transaction() {

  prepare(acct: AuthAccount) {
    let myTaskList <- TaskTracker.createTaskList()
    acct.save(<- myTaskList, to: /storage/MyTaskList)
  }

  execute {}

}
