##  params:
##    content: Rule definition
##    order:   Relative order of this rule

define auditd::rule($content='', $order=10) {
  if $content == '' {
    $body = $name
  } else {
    $body = $content
  }

  validate_numeric($order)
  validate_string($body)

  concat::fragment{ "auditd_fragment_${name}":
    target  => $auditd::params::rules_file,
    order   => $order,
    content => $body,
  }
}
