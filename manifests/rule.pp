##  params:
##    content: Rule definition
##    order:   Relative order of this rule

define auditd::rule(
  String $content                 = '',
  Variant[Integer, String] $order = 10,
) {

  if $content == '' {
    $body = $name
  } else {
    $body = $content
  }

  concat::fragment{ "auditd_fragment_${name}":
    target  => $auditd::rules_file,
    order   => $order,
    content => $body,
  }

}
