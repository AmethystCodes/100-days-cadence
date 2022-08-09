import TaskTracker from 0x01

transaction(idx: Int) {

    prepare(acct: AuthAccount) {
    
        let myTaskList = acct.borrow<&TaskTracker.TaskList>(from: /storage/MyTaskList)
            ?? panic("Nothing lives at this path")
        myTaskList.removeTask(idx: idx)
    }

    execute {}

}
