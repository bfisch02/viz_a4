class Firewall {
  String time;
  String sourceIP;
  String sourcePort;
  String destIP;
  String destPort;
  String syslog;
  String operation;
  String protocol;
  boolean mouseover;
  
  Firewall(String time, String sourceIP, String sourcePort,
           String destIP, String destPort, String syslog,
           String operation, String protocol)
  {
    this.time = time;
    this.sourceIP = sourceIP;
    this.sourcePort = sourcePort;
    this.destIP = destIP;
    this.destPort = destPort;
    this.syslog = syslog;
    this.operation = operation;
    this.protocol = protocol; 
  }
  
  
  
}
