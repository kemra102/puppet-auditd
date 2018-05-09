##  params:
##    content: Rule definition
##    order:   Relative order of this rule

define auditd::rule($content='', $order=10) {
  if $content == '' {
    $body = $name
  } else {
    $body = $content
  }

  if (!is_numeric($order) and !is_string($order))
  {
    fail('$order must be a string or an integer')
  }
  validate_string($body)

  concat::fragment{ "auditd_fragment_${name}":
    target  => $auditd::rules_file,
    order   => $order,
    content => $body,
  }
}
