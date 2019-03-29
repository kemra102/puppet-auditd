type Auditd::WatchRule = Struct[{
  files                 => Array[Stdlib::Unixpath,1],
  Optional[permissions] => Array[Enum['r','w','x','a'],1],
  Optional[keys]        => Array[String[1]],
}]
