component singleton accessors="true" {

  /**
  * Array with threads java
  *
  */
  function threads_java()
  {
    return CreateObject( "java", "java.lang.Thread" ).getAllStackTraces().keySet().toArray();
  }

  /**
  * Array of threads created with cfthread
  *
  */
  function threads_cf()
  {
    var java_threads = threads_java();
	var ret = [];
	var luceeVer = listFirst( server.lucee.version, "." );

    for (var jthread in java_threads)
    {
      if (jthread.getname() contains "cfthread")
      {
		  if( luceeVer < 5 ) {
			  // worked in 4.5
			arrayappend(ret, jthread.getThreadScope());
		  }
		  else if( luceeVer >= 5 ) {
			arrayappend( ret, { name= jThread.getTagName(), status = jThread.getState().name() } );
		  }
      }
	}
    return ret;
  }

  /**
  *  resturn the state of a cfthread
  *
  *  @thread_name: Nombre del thread cuando se creó con cfthread.
  *  @return: boolean
  */
  function status(string cfthread_name)
  {
    var cf_threads = threads_cf();
    for (var mythread in cf_threads)
    {
      if (mythread.name eq arguments.cfthread_name)
      {
        return mythread.status;
      }
    }
    return "NOT RUNNING"
  }

  /**
  *  check if a thread is running
  *
  *  @thread_name: name of the cfthread.
  *  @return: boolean
  */
  function is_running(string cfthread_name)
  {
    var cf_threads = threads_cf();
    for (var mythread in cf_threads)
    {
      if (mythread.name eq arguments.cfthread_name and listFindNoCase( "RUNNING,RUNNABLE,WAITING,BLOCKED", mythread.status ) )
      {
        return true;
      }
    }
    return false;
  }
}
